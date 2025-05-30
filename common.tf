variable "ami_id" {}
variable "instance_type" {}
variable "key_name" {}
variable "security_group" {}
variable "iam_instance_profile" {}
variable "aws_region" {}
variable "vpc" {}
variable "subnet" {}

# var.aws_region
provider "aws" {
  region = "us-west-2"
}