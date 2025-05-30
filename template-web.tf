resource "aws_instance" "test" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet
  vpc_security_group_ids = [var.security_group]
  key_name               = var.key_name

  tags = {
    Name = "terraform-test-instance"
  }
}