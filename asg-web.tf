resource "aws_autoscaling_group" "demo_asg" {
  desired_capacity     = 2
  max_size             = 3
  min_size             = 1
  vpc_zone_identifier  = [var.vpc]

  launch_template {
    id      = aws_launch_template.ec2_template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "asg-demo"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}
