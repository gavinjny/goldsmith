# Uses AWS creds/region from your GitHub Actions secrets
provider "aws" {}

# provider "aws" {
#   alias = "k8s"

#   assume_role {
#     role_arn     = var.pipeline_role_arn
#     session_name = "tf-k8s"
#   }
# }