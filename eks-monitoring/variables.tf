variable "cluster_name" {
  description = "EKS cluster name (pipeline passes EKS_CLUSTER_NAME)"
  type        = string
}
variable "pipeline_role_arn" {
  description = "IAM role ARN that the pipeline assumes"
  type        = string
}module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.24"

  cluster_name                   = var.cluster_name
  cluster_version                = local.k8s_version
  cluster_endpoint_public_access = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_groups = {
    default = {
      instance_types = ["t3.medium"] # t2.micro is very tight for Prom/Grafana
      desired_size   = 2
      min_size       = 1
      max_size       = 3
    }
  }

  # 👇 Avoid the aws_iam_session_context (no iam:GetRole needed)
  enable_cluster_creator_admin_permissions = false

  # 👇 Explicitly grant your pipeline role cluster-admin
  manage_aws_auth = true
  access_entries = {
    gha = {
      principal_arn       = var.pipeline_role_arn
      kubernetes_username = "github-actions"
      kubernetes_groups   = ["system:masters"]
    }
  }
}
