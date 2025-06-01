resource "aws_autoscaling_group" "demo_asg" {
  name                 = "asg-web-demo"
  desired_capacity     = 2
  max_size             = 3
  min_size             = 1
  vpc_zone_identifier  = var.aws_vpc_zone_identifier

launch_template {
  id      = aws_launch_template.ec2_template.id
  version = "$Latest"  
}

  tag {
    key                 = "Name"
    value               = "ec2-web-demo"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_instance_refresh" "refresh" {
  autoscaling_group_name = aws_autoscaling_group.demo_asg.name

  preferences {
    min_healthy_percentage = 100
    instance_warmup        = 300
  }

  triggers = ["launch_template"]
}