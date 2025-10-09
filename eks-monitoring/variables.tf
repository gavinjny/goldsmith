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