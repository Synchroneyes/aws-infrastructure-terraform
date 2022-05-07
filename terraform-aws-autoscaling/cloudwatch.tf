resource "aws_autoscaling_policy" "politique_autoscalingout" {
  name                   = "${var.vpc_name}-autoscaling-policy"
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 30
  autoscaling_group_name = aws_autoscaling_group.autoscaling.name
  scaling_adjustment  = 1
}

resource "aws_autoscaling_policy" "politique_autoscalingin" {
  name                   = "${var.vpc_name}-autoscaling-policy"
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 30
  autoscaling_group_name = aws_autoscaling_group.autoscaling.name
  scaling_adjustment  = -1
}


resource "aws_cloudwatch_metric_alarm" "bat" {
  alarm_name          = "Augmenter nombre ec2 si cpu % > 30"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  period              = "60"
  statistic           = "Maximum"
  threshold           = "30" #%
  namespace           = "AWS/EC2"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.autoscaling.name
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = [aws_autoscaling_policy.politique_autoscalingout.arn]
}

resource "aws_cloudwatch_metric_alarm" "diminuer" {
  alarm_name          = "Diminuer nombre ec2 si cpu % < 15"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  period              = "60"
  statistic           = "Maximum"
  threshold           = "15" #%
  namespace           = "AWS/EC2"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.autoscaling.name
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = [aws_autoscaling_policy.politique_autoscalingin.arn]
}