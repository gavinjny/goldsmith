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
      instance_types = ["t3.medium"]
      desired_size   = 2
      min_size       = 1
      max_size       = 3
    }
  }

  enable_cluster_creator_admin_permissions = false


  # manage_aws_auth = true
  access_entries = {
    gha = {
      principal_arn       = var.pipeline_role_arn   # you pass this in
      kubernetes_username = "github-actions"
      kubernetes_groups   = ["system:masters"]
    }
  }
}
