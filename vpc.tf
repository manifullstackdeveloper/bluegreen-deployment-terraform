variable "vpc_id" {
  default = "20.0.0.0/16"
}

variable "application_environment" {
  default = "bluegreen-deployment"
}

# VPC
resource "aws_vpc" "bluegreen_aws_vpc" {
  cidr_block           = var.vpc_id
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  //enable_classiclink   = "false"
  tags = {
    Name        = "bluegreen_aws_vpc"
    Environment = var.application_environment
  }
}


#IGW
resource "aws_internet_gateway" "bluegreen_igw" {
  vpc_id = aws_vpc.bluegreen_aws_vpc.id
  tags = {
    "Name"      = "BlueGreen-Internet-Gateway"
    Environment = "${var.application_environment}"
  }
}

