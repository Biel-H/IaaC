terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-2"
}

resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "VPC-teste"
    }
}
resource "aws_security_group" "allow_tls"{
    name    = "allow_tls"
    description = "Allow TLS inbound traffic"
    vpc_id  = aws_vpc.main.id

    ingress {
        description = "TLS from VPC "
        from_port       = 443
        to_port         = 443
        protocol        = "tcp"
        cidr_blocks     = [aws_vpc.main.cidr_block]
    }

    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
    }

    tags = {
        Name = "Allow_tls"
    }
}

resource "aws_default_subnet" "default_az1"{
    availability_zone = "us-east-2a"
    

    tags = {
        Name = "Subnet-Terraform"
    }
}
