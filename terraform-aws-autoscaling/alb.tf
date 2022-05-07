resource "aws_lb" "alb" {
  name               = "${var.vpc_name}-alb-public"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = module.discovery.public_subnets

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_target_group" "alb_tg" {
  name     = "${var.vpc_name}-web-alb-http"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = module.discovery.vpc_id


  health_check {
      healthy_threshold = 2
      unhealthy_threshold = 2
  }

}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}

resource "aws_security_group" "alb_sg" {
  name        = "${var.vpc_name}-alb-sg"
  description = "Autoriser le traffic sur le port 80"
  vpc_id      = module.discovery.vpc_id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }


}

resource "aws_security_group_rule" "allow_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb_sg.id
}