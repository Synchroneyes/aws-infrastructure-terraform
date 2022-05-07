resource "aws_autoscaling_group" "autoscaling" {

  max_size           = 3
  min_size           = 1

  vpc_zone_identifier = module.discovery.private_subnets
  target_group_arns = [aws_lb_target_group.alb_tg.arn]

  launch_template {
    id      = aws_launch_template.launch_template.id
    version = "$Latest"
  }
}


resource "aws_launch_template" "launch_template" {
  name_prefix = "${var.vpc_name}-lt-"


  image_id = module.discovery.images_id[0]
  instance_type = "t2.micro"

  vpc_security_group_ids = [aws_security_group.asg_sg.id]
  user_data = filebase64("${path.module}/instance-start.sh")

}


resource "aws_security_group" "asg_sg" {
  name        = "${var.vpc_name}-asg-sg"
  description = "Autoriser le traffic entre le load balancer et ASG"
  vpc_id      = module.discovery.vpc_id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

}

resource "aws_security_group_rule" "allow_http_asg" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  security_group_id = aws_security_group.asg_sg.id
  source_security_group_id    =   aws_security_group.alb_sg.id
}


