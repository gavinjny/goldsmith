variable "aws_region" {
  type    = string
  default = "default"
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "ami-storefront-{{timestamp}}"
  instance_type = "t2.micro"
  region        = "${var.aws_region}"
  ssh_username = "ubuntu"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"] # Canonical
  }
}

build {
  sources = ["source.amazon-ebs.ubuntu"]
  provisioner "shell" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y nginx"
    ]
  }
}
