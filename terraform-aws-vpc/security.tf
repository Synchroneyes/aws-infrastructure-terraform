resource "aws_security_group" "ops" {
  name        = "ops"
  description = "Allow SSH & WEB (22, 80)"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name = "ops"
  }
}

resource "aws_security_group_rule" "ops_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [aws_vpc.vpc.cidr_block, var.vpc_cidr_all]
  security_group_id = aws_security_group.ops.id
}

resource "aws_security_group_rule" "ops_web" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = [aws_vpc.vpc.cidr_block, var.vpc_cidr_all]
  security_group_id = aws_security_group.ops.id
}

resource "aws_security_group_rule" "communicate_outside" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = [aws_vpc.vpc.cidr_block, var.vpc_cidr_all]
  security_group_id = aws_security_group.ops.id
}


resource "aws_security_group_rule" "communicate_inside_vpc_nat" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = [aws_vpc.vpc.cidr_block]
  security_group_id = aws_security_group.ops.id
}