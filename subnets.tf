# Declare the data source
data "aws_availability_zones" "azs" {
  state = "available"
}

locals {
  subnet_count       = 1
  availability_zones = ["us-west-2a"]
}

resource "aws_subnet" "terraform-blue-green" {
  count                   = "${local.subnet_count}"
  vpc_id                  = "${aws_vpc.bluegreen_aws_vpc.id}"
  availability_zone       = "${element(local.availability_zones, count.index)}"
  cidr_block              = "20.0.${local.subnet_count * (var.infrastructure_version - 1) + count.index + 1}.0/26"
  map_public_ip_on_launch = true

  tags = {
    Name = "${element(local.availability_zones, count.index)} (v${var.infrastructure_version})"
  }
}


# route associations public
resource "aws_route_table_association" "pub_sub_association" {
  count          = 1
  subnet_id      = aws_subnet.terraform-blue-green.*.id[0]
  route_table_id = aws_route_table.terraform-blue-green-route_table_public.id
}

#route table for public subnets
resource "aws_route_table" "terraform-blue-green-route_table_public" {
  vpc_id = aws_vpc.bluegreen_aws_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.bluegreen_igw.id
  }

  tags = {
    "Name"      = "terraform-blue-green-route_table_public"
    Environment = "${var.application_environment}"
  }
}