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
  desired_capacity    = 2
  max_size            = 3
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
