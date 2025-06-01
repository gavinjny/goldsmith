terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.6.0" # Or a newer specific version like "~> 5.0"
    }
  }
}