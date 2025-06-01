terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.6.0" # Ensure this line specifies a compatible version
    }
  }
}