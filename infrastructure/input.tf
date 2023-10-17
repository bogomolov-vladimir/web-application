variable "access_key" {}
variable "secret_key" {}
variable "ami" {}

variable "region" {
    default = "eu-west-2"
}

# RSA key of size 4096 bits
resource "tls_private_key" "rsa-4096" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

variable "key_name" {}

resource "aws_key_pair" "key_pair" {
  key_name   = var.key_name
  public_key = tls_private_key.rsa-4096.public_key_openssh
}

resource "local_file" "private_key" {
    content = tls_private_key.rsa-4096.private_key_pem
    filename = var.key_name
}

data "http" "my_public_ip" {
    url = "https://ifconfig.co/json"
    request_headers = {
        Accept = "application/json"
    }
}

locals {
  ifconfig_co_json = jsondecode(data.http.my_public_ip.body)
}