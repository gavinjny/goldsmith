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
