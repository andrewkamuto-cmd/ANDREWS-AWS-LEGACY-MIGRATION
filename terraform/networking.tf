# VPC
resource "aws_vpc" "swaggertys_vpc" {
  cidr_block           = "10.20.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "${var.project_name}-vpc"
    Environment = var.environment
    Project     = "Legacy-Web-Migration"
  }
}

# Subnets
resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.swaggertys_vpc.id
  cidr_block              = "10.20.1.0/24"
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-1"
  }
}

resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.swaggertys_vpc.id
  cidr_block              = "10.20.2.0/24"
  availability_zone       = "us-east-2b"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-2"
  }
}

resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.swaggertys_vpc.id
  cidr_block        = "10.20.11.0/24"
  availability_zone = "us-east-2a"

  tags = {
    Name = "${var.project_name}-private-1"
  }
}

resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.swaggertys_vpc.id
  cidr_block        = "10.20.12.0/24"
  availability_zone = "us-east-2b"

  tags = {
    Name = "${var.project_name}-private-2"
  }
}
