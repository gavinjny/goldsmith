terraform {
  backend "s3" {
    bucket        = "s3-config-state"
    key           = "terraform.tfstate"
    region        = "us-west-2"
    use_lockfile  = true
  }
}



