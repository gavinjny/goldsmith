resource "aws_launch_template" "ec2_template" {
  name_prefix   = "lt-web-demo-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = var.security_group
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "lt-web-demo"
    }
  }
}

resource "aws_lb" "app_alb" {
  name               = "alb-web-demo"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_group
  subnets            = var.aws_vpc_zone_identifier
}

# Target Groups
resource "aws_lb_target_group" "v1" {
  name     = "v1"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc
}

resource "aws_lb_target_group" "v2" {
  name     = "v2"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc
}

# Auto Scaling Group - Stable (v1)
resource "aws_autoscaling_group" "asg_v1" {
  name                = "asg-web-demo-v1"
  desired_capacity    = 1
  max_size            = 2
  min_size            = 1
  vpc_zone_identifier = var.aws_vpc_zone_identifier

  target_group_arns = [aws_lb_target_group.v1.arn]

  launch_template {
    id      = aws_launch_template.ec2_template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "ec2-web-demo-v1"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Auto Scaling Group - Canary (v2)
resource "aws_autoscaling_group" "asg_v2" {
  name                = "asg-web-demo-v2"
  desired_capacity    = 1
  max_size            = 2
  min_size            = 1
  vpc_zone_identifier = var.aws_vpc_zone_identifier

  target_group_arns = [aws_lb_target_group.v2.arn]

  launch_template {
    id      = aws_launch_template.ec2_template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "ec2-web-demo-v2"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Scale Out Policy (add 1 instance if CPU > 70%)
resource "aws_autoscaling_policy" "scale_out" {
  name                   = "scale-out-policy"
  autoscaling_group_name = aws_autoscaling_group.asg_v1.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 1
  cooldown               = 300
}

resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "high-cpu-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 70
  alarm_description   = "Trigger scale-out when CPU > 70% for 2 minutes"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg_v1.name
  }
  alarm_actions = [aws_autoscaling_policy.scale_out.arn]
}

# Scale In Policy (remove 1 instance if CPU < 20%)
resource "aws_autoscaling_policy" "scale_in" {
  name                   = "scale-in-policy"
  autoscaling_group_name = aws_autoscaling_group.asg_v1.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1
  cooldown               = 300
}

resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  alarm_name          = "low-cpu-alarm"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 20
  alarm_description   = "Trigger scale-in when CPU < 20% for 2 minutes"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg_v1.name
  }
  alarm_actions = [aws_autoscaling_policy.scale_in.arn]
}
