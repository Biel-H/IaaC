resource "aws_vpc" "PRD-ECS"{
    cidr_block  = "10.0.0.0/16"
    instance_tenancy = "default"
    tags = {
        Name = "PRD-ECS"
    }
}

resource "aws_subnet" "terranet-pub-1"{
    vpc_id      = aws_vpc.main.id
    cidr_block  ="10.0.1.0/24"
    map_public_ip_on_launch = "true"
    availability_zone   = "us-east-2a"

    tags    = {
        Name = "terranet-pub-1"
    }
}

resource "aws_subnet" "terranet-pub-2"{
    vpc_id      = aws_vpc.main.id
    cidr_block  ="10.0.2.0/24"
    map_public_ip_on_launch = "true"
    availability_zone   = "us-east-2b"

    tags    = {
        Name = "terranet-pub-2"
    }
}

resource "aws_subnet" "terranet-pub-3"{
    vpc_id      = aws_vpc.main.id
    cidr_block  ="10.0.3.0/24"
    map_public_ip_on_launch = "true"
    availability_zone   = "us-east-2c"

    tags    = {
        Name = "terranet-pub-3"
    }
}

resource "aws_subnet" "terranet-priv-1"{
    vpc_id      = aws_vpc.main.id
    cidr_block  ="10.0.4.0/24"
    map_public_ip_on_launch = "false"
    availability_zone   = "us-east-2a"

    tags    = {
        Name = "terranet-priv-1"
    }
}

resource "aws_subnet" "terranet-priv-2"{
    vpc_id      = aws_vpc.main.id
    cidr_block  ="10.0.5.0/24"
    map_public_ip_on_launch = "false"
    availability_zone   = "us-east-2b"

    tags    = {
        Name = "terranet-priv-2"
    }
}


resource "aws_internet_gateway" "main"{
    vpc_id  = aws_vpc.main.id

    tags = {
        Name = "GW-terraform"
        Enviroment = "PDR"
    }
}

resource "aws_eip"  "terraeip" {
    vpc     = true

    tags = {
        Name = "EIP-terraform"
    }
}

resource "aws_nat_gateway"  "terranat"{
    allocation_id   = aws_eip.terraeip.id
    subnet_id   = aws_subnet.terranet-priv-1.id
    depends_on  = [aws_internet_gateway.main]

    tags = {
        Name = "terranat"
    }
}

resource "aws_route_table"  "main"{
    vpc_id  = aws_vpc.main.id

    route {
        //associate subnet can reach everywhere
        cidr_block = "0.0.0.0/0"

        //CTR uses this IGW to reach internet
        gateway_id  = aws_internet_gateway.main.id
    }

    tags = {
        Name = "terraroute-pub"
    }
}
resource "aws_route_table"  "private" {
    vpc_id  = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id  = aws_nat_gateway.terranat.id
    }

    tags = {
        Name = "terraroute-priv"
    }
}

resource "aws_route_table_association"  "terranet-crta-pub-1"{
    subnet_id   = aws_subnet.terranet-pub-1.id
    route_table_id  = aws_route_table.main.id
}

resource "aws_route_table_association"  "terranet-crta-pub-2"{
    subnet_id   = aws_subnet.terranet-pub-2.id
    route_table_id  = aws_route_table.main.id
}

resource "aws_route_table_association"  "terranet-crta-pub-3"{
    subnet_id   = aws_subnet.terranet-pub-3.id
    route_table_id  = aws_route_table.main.id
}

resource "aws_route_table_association"  "terranet-ctra-priv-1"{
    subnet_id   = aws_subnet.terranet-priv-1.id
    route_table_id  = aws_route_table.private.id
}

resource "aws_route_table_association"  "terranet-ctra-priv-2"{
    subnet_id   = aws_subnet.terranet-priv-2.id
    route_table_id  = aws_route_table.private.id
}

resource "aws_network_acl"  "main"{
    vpc_id  = aws_vpc.main.id

    egress {
        protocol    = "tcp"
        rule_no    = 200
        action     = "allow"
        cidr_block = "0.0.0.0/0"
        from_port  = 0
        to_port    = 0
    }
    ingress {   
        protocol   = "tcp"
        rule_no    = 100
        action     = "allow"
        cidr_block = "0.0.0.0/0"
        from_port  = 0
        to_port    = 0
  }

  tags = {
      Name = "terranlc"
  }
}
