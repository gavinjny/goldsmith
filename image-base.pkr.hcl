variable "aws_region" {
  type    = string
  default = "default"
}

variable "version" {
  type    = string
  default = "default"
}


packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  ami_name               = "snapshot-demo-base-${var.version}"
  instance_type          = "t2.micro"
  region                 = var.aws_region
  ssh_username           = "ubuntu"
  ami_description        = "Base Ubuntu AMI based on t2.micro with updates"
  associate_public_ip_address = true

  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    owners      = ["099720109477"] # Canonical (official Ubuntu AMIs)
    most_recent = true
  }

  tags = {
    Name        = "ami-demo-base-${var.version}"
    CreatedBy   = "Goldsmith pipeline"
    Environment = "Prod"
  }
}

build {
  sources = ["source.amazon-ebs.ubuntu"]
  
# Configure base image
  provisioner "file" {
    source      = "image-base.sh"
    destination = "/tmp/image-base.sh"
  }

  provisioner "shell" {
    inline = [
      "chmod +x /tmp/image-base.sh",
      "sudo /tmp/image-base.sh"
    ]
  }
}
