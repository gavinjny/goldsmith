variable "ami_id" {}
variable "instance_type" {}
variable "key_name" {}
variable "security_group" {}
variable "iam_instance_profile" {}
variable "aws_region" {}
variable "vpc" {}
variable "subnet" {}

provider "aws" {
  region = var.aws_region
}

resource "aws_launch_template" "storefront" {
  name_prefix   = "storefront-web-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  iam_instance_profile {
    name = var.iam_instance_profile
  }

  vpc_security_group_ids = [var.security_group]

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "storefront-autoscale"
    }
  }
}

resource "aws_autoscaling_group" "storefront_asg" {
  desired_capacity     = 2
  max_size             = 3
  min_size             = 1
  vpc_zone_identifier  = [var.vpc]

  launch_template {
    id      = aws_launch_template.storefront.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "storefront-asg-instance"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}
