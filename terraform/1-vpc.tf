# Create a vpc
resource "aws_vpc" "dev_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

#Create an igw
resource "aws_internet_gateway" "igw" {
  vpc_id = local.vpc_id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

#Use data source to get a list of all availability zones in a region
data "aws_availability_zones" "availability_zones" {}

#Create public subnet az1
resource "aws_subnet" "dev_public_subnet_az1" {
  vpc_id                  = local.vpc_id
  cidr_block              = var.pub_sub_az1_cidr
  availability_zone       = data.aws_availability_zones.availability_zones.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-subnet-az1"
  }
}

#Create public subnet az2
resource "aws_subnet" "dev_public_subnet_az2" {
  vpc_id                  = local.vpc_id
  cidr_block              = var.pub_sub_az2_cidr
  availability_zone       = data.aws_availability_zones.availability_zones.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-subnet-az2"
  }
}


#Create public route table
resource "aws_route_table" "public_route_table" {
  vpc_id = local.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.project_name}-public-rt"
  }
}

#Associate public subnet in az1 to "public route table"
resource "aws_route_table_association" "az1_pub_sub_rt_association" {
  subnet_id      = aws_subnet.dev_public_subnet_az1.id
  route_table_id = aws_route_table.public_route_table.id
}

#Associate public subnet in az2 to "public route table"
resource "aws_route_table_association" "az2_pub_sub_rt_association" {
  subnet_id      = aws_subnet.dev_public_subnet_az2.id
  route_table_id = aws_route_table.public_route_table.id
}