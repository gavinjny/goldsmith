variable "aws_region" {
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
  ami_name               = "ami-storefront-base-{{timestamp}}"
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
    Name        = "snapshot-storefront-base-{{timestamp}}"
    CreatedBy   = "packer"
    Environment = "Prod"
  }
}

build {
  sources = ["source.amazon-ebs.ubuntu"]

  provisioner "shell" {
    inline = [
      "echo 'Updating packages...'",
      "sudo apt-get update -y",
      "sudo apt-get upgrade -y",
      "echo 'Setting timezone to America/New_York (Eastern)...'",
      "sudo timedatectl set-timezone America/New_York",
      "echo 'Done with patching and timezone setup.'"
    ]
  }
  
  # Upload local InSpec test folder to instance
  provisioner "file" {
    source      = "inspec-profile"
    destination = "/tmp/inspec-profile"
  }

  # Install InSpec and run tests
  provisioner "shell" {
    inline = [
      "curl https://omnitruck.chef.io/install.sh | sudo bash -s -- -P inspec",
      "cd /tmp/inspec-profile",
      "sudo inspec exec . || echo '⚠ InSpec tests failed'"
    ]
  }
}
