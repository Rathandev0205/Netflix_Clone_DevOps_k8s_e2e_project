locals {
  project     = "netflix-clone"
  org         = "rathan-dev"
  environment = "var.env"

}

resource "aws_vpc" "vpc" {
  cidr_block       = var.cidr_block
  instance_tenancy = "default"

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "${local.org}-${local.project}-${var.env}-vpc"
    environment = var.env
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id     = aws_vpc.vpc.id
  depends_on = [aws_vpc.vpc]

  tags = {
    Name        = "${local.org}-${local.project}-${var.env}-igw"
    environment = var.env
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.vpc.id

  map_public_ip_on_launch = true
  count                   = var.pub_subnet_count
  cidr_block              = var.pub-cidr_block[count.index]
  availability_zone       = var.availability_zones[count.index]
  depends_on              = [aws_vpc.vpc]

  tags = {
    Name        = "${local.org}-${local.project}-${var.env}-public-subnet-${count.index + 1}"
    environment = var.env
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id     = aws_vpc.vpc.id
  depends_on = [aws_vpc.vpc]

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name        = "${local.org}-${local.project}-${var.env}-public-rt"
    environment = var.env
  }
}

resource "aws_route_table_association" "public_rt_assoc" {
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_rt.id
  count          = var.pub_subnet_count
  depends_on     = [aws_subnet.public_subnet, aws_route_table.public_rt]

}

resource "aws_security_group" "public_sg" {
  # ... other configuration ...

  name        = "${local.org}-${local.project}-${var.env}-public-sg"
  description = "Security group for public instances"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name        = "${local.org}-${local.project}-${var.env}-public-sg"
    environment = var.env
  }
}