#----------------------------------------------------------
# Provision Remote State Highly Available Web in any Region with own VPC
#   - Remote State
#   - Zero DownTime
#   - Green/Blue Deployment
#
# Create: 
#    - Use Terraform Backend to connect S3 bucket to save project remotely
#    - Create VPC
#    - Create Internet Gateway with Attached VPC
#    - Create Subnets with custom CIDRs
#    - Create Route Table with Attached VPC and Internet Gateway
#    - Create Route Table Association with Subnets
#
# Made by Vitali Aleksandrov 28-April-2023
#-----------------------------------------------------------

provider "aws" {
  region = "eu-central-1"
}

# Copying terraform.tfstate file to S3 bucket to change edit project from Remote State
terraform {
  backend "s3" {
    bucket = "daisuke-terraform"             # Enter your S3 Bucket name
    key    = "dev/network/terraform.tfstate" # Copying to dev/network directory
    region = "eu-central-1"                  # Enter your Region
  }
}

# Creating VPC
resource "aws_vpc" "main" {
  cidr_block = var.cidr_block # Using CIDR BLOCKS from variable

  tags = {
    Name = "${var.env}-VPC"
  }
}

# Creating Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.env}-IGW"
  }
}

# Creating create as many Subnets as CIDR BLOCKS indicated 
resource "aws_subnet" "public_subnets" {
  count                   = length(var.public_subnet_cidrs) # Getting value of CIDR BLOCKS
  vpc_id                  = aws_vpc.main.id
  cidr_block              = element(var.public_subnet_cidrs, count.index)            # Attaching CIDR BLOCKS by Index
  availability_zone       = data.aws_availability_zones.available.names[count.index] # Using Availability Zones by Index
  map_public_ip_on_launch = true                                                     # Auto Allocate  Public IPv4

  tags = {
    Name = "${var.env}-Subnet-${count.index + 1}" # Making {count.index + 1} to make last number more than 0 for better view
  }
}

# Creating Route Table and Attaching Internet Gateway
resource "aws_route_table" "public_subnets" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id # Attaching Internet Gateway
  }

  tags = {
    Name = "${var.env}-Public-RouteTable"
  }
}

# Associating Route Table to Subnets
resource "aws_route_table_association" "public_routes" {
  count          = length(aws_subnet.public_subnets[*].id)
  route_table_id = aws_route_table.public_subnets.id
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
}
