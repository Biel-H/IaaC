resource "aws_security_group" "Terra_sg"{
    name    = "Terra_sg"
    description = "Grupo de seguraca para testes em terraform"
    vpc_id  = aws_vpc.main.id

    ingress {
        description = "HTTPS para a vpc"
        from_port       = 443
        to_port         = 443
        protocol        = "tcp"
        cidr_blocks     = [aws_vpc.main.cidr_block]
    }

    ingress {
        description = "Http para a vpc"
        from_port   =   80
        to_port =   80
        protocol    =   "tcp"
        cidr_blocks  =   ["0.0.0.0/0"]
    }

    ingress {
        description = "Permitir o  ssh"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = [aws_vpc.main.cidr_block]
    }


    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
    }

    tags = {
        Name = "Permitir portas"
    }
}

resource "aws_default_subnet" "default_az1"{
    availability_zone = "us-east-2a"
    

    tags = {
        Name = "Subnet-Terraform"
    }
}
