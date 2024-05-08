resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "dev-vpc"
  }
}

resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-west-2a"
  tags = {
    Name = "dev-public"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-gw"
  }
}


resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "dev-public-route_table"
  }
}

resource "aws_route" "r" {
  route_table_id         = aws_route_table.rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
  depends_on             = [aws_route_table.rt]
}

resource "aws_route_table_association" "rt-association" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.rt.id
}



locals {
  port_in  = [443, 80, 22]
  port_out = [0]
}

resource "aws_security_group" "allow_sgs" {
  name        = "dev-sg"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.main.id


  dynamic "ingress" {
    for_each = toset(local.port_in)
    content {
      description = "HTTPS from vpc"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

  }

  dynamic "egress" {
    for_each = toset(local.port_out)
    content {
      from_port   = egress.value
      to_port     = egress.value
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }



  }
  tags = {
    Name = "allow_sgs"
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "mykey"
  public_key = file("mykey.pub")
}