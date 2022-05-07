resource "aws_instance" "ec2_private" {
  for_each      = var.vpc_azs
  ami           = data.aws_ami.ami.id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.private[each.key].id
  key_name      = aws_key_pair.ssh_key.key_name
  vpc_security_group_ids = [aws_security_group.ops.id]
  source_dest_check = false
  

  tags = {
    Name = "${var.vpc_name}-ec2-private-${var.aws_region}${each.key}"
  }

}
resource "aws_instance" "ec2_public" {
  for_each      = var.vpc_azs
  ami           = data.aws_ami.ami.id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public[each.key].id
  key_name      = aws_key_pair.ssh_key.key_name
  vpc_security_group_ids = [aws_security_group.ops.id]
  source_dest_check = false

  tags = {
    Name = "${var.vpc_name}-ec2-public-${var.aws_region}${each.key}"
  }

}
