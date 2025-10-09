data "aws_caller_identity" "current" {}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.24"

  cluster_name                   = var.cluster_name
  cluster_version                = local.k8s_version
  cluster_endpoint_public_access = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_groups = {
    default = {
      instance_types = ["t2.micro"]
      desired_size   = 2
      min_size       = 1
      max_size       = 3
    }
  }

  # Map the caller (your pipeline IAM identity) so Helm/K8s providers can deploy
  access_entries = [
    {
      kubernetes_username = "github-actions"
      kubernetes_groups   = ["system:masters"]
      principal_arn       = data.aws_caller_identity.current.arn
    }
  ]
}
