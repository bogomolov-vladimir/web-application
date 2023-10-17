provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "application-vpc"
  cidr = "10.0.0.0/16"

  azs            = ["${var.region}a"]
  public_subnets = ["10.0.101.0/24"]

  tags = {
    createdBy = "%username%"
  }
}

resource "random_string" "random" {
  length           = 3
  special          = true
  override_special = "/@£$"
}

resource "aws_instance" "app_vm" {
  ami                         = var.ami
  instance_type               = "t2.micro"
  subnet_id                   = module.vpc.public_subnets[0]
  vpc_security_group_ids      = [aws_security_group.vm_sg.id]
  key_name                    = aws_key_pair.key_pair.key_name
  associate_public_ip_address = false

  tags = {
    Name      = "application-vm"
  }
}

resource "aws_eip" "elastic_ip" {
  instance = aws_instance.app_vm.id
  domain      = "vpc"
}

resource "aws_security_group" "vm_sg" {
  name        = "Allow incoming connections."
  description = "security group using Terraform"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${local.ifconfig_co_json.ip}/32"]
  }

  # application
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    tags = {
    Name = "erply_sg"
  }

}
