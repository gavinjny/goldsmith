variable "ami_id" {
    type = string
}
variable "instance_type" {
    type = string
}
variable "key_name" {
    type = string
}
variable "security_group" {
    type = list(string)
}
variable "aws_region" {
    type = string
}
variable "vpc" {
    type = string
}
variable "subnet" {
    type = string
}
variable "aws_vpc_zone_identifier" {
    type = list(string)
}
