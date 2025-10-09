variable "cluster_name" {
  description = "EKS cluster name (pipeline passes EKS_CLUSTER_NAME)"
  type        = string
}
variable "pipeline_role_arn" {
  description = "IAM role ARN that the pipeline assumes"
  type        = string
}
variable "aws_region" {
    type = string
}
variable "instance_type" {
    type = string
}
variable "vpc" {
    type = string
}
variable "subnet" {
    type = string
}
variable "aws_vpc_zone_identifier" {
    type = string
}
variable "key_name" {
    type = string
}
variable "security_group" {
    type = string
}
