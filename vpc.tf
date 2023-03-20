# Let's create a VPC

resource "aws_vpc" "binary_dr_vpc_main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "Binary DR VPC"
  }
}

resource "aws_subnet" "us_east_1a_10_0_1_0" {
  vpc_id     = "${aws_vpc.binary_dr_vpc_main.id}"
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "Binary DR 10.0.1.0 us-east-1a"
  }
}

resource "aws_subnet" "us_east_1b_10_0_2_0" {
  vpc_id     = "${aws_vpc.binary_dr_vpc_main.id}"
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = false

  tags = {
    Name = "Binary DR 10.0.2.0 us-east-1b"
  }
}

resource "aws_subnet" "us_east_us_east_1f_replication" {
  vpc_id     = "${aws_vpc.binary_dr_vpc_main.id}"
  cidr_block = "10.0.6.0/24"
  availability_zone = "us-east-1f"
  map_public_ip_on_launch = false

  tags = {
    Name = "Binary DR 10.0.6.0 replication us-east-1f"
  }
}

resource "aws_internet_gateway" "binary_dr_internet_gw" {
  vpc_id = "${aws_vpc.binary_dr_vpc_main.id}"

  tags = {
    Name = "Binary DR Internet Gateway"
  }
}

resource "aws_route_table" "binary_dr_route_table" {
  vpc_id = "${aws_vpc.binary_dr_vpc_main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.binary_dr_internet_gw.id}"
  }

  tags = {
    Name = "Binary DR Route Table"
  }
}
resource "aws_main_route_table_association" "binary_dr_main_route" {
  vpc_id         = aws_vpc.binary_dr_vpc_main.id
  route_table_id = aws_route_table.binary_dr_route_table.id
}

# resource "aws_route_table" "binary_dr_route_table_private" {
#   vpc_id = "${aws_vpc.binary_dr_vpc_main.id}"

#   route {
#     cidr_block = "0.0.0.0/0"
#     nat_gateway_id = "${aws_nat_gateway.binary_dr_nat_gw.id}"
#   }

#   tags = {
#     Name = "Binary DR Route Table Private to NAT gw"
#   }
# }


# resource "aws_route_table_association" "binary_dr_assoc_public_subnet" {
#   subnet_id      = "${aws_subnet.us_east_1a_10_0_1_0.id}"
#   route_table_id = "${aws_route_table.binary_dr_route_table_public.id}"
# }
# resource "aws_route_table_association" "binary_dr_assoc_private_subnet" {
#   subnet_id      = "${aws_subnet.us_east_1b_10_0_2_0.id}"
#   route_table_id = "${aws_route_table.binary_dr_route_table_private.id}"
# }
# resource "aws_route_table_association" "binary_dr_assoc_private_subnet_replication" {
#   subnet_id      = "${aws_subnet.us_east_us_east_1f_replication.id}"
#   route_table_id = "${aws_route_table.binary_dr_route_table_private.id}"
# }

# EIP and NAT GW
resource "aws_eip" "binary_dr_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.binary_dr_internet_gw]
}

# resource "aws_nat_gateway" "binary_dr_nat_gw" {
#   allocation_id = "${aws_eip.binary_dr_eip.id}"
#   subnet_id     = "${aws_subnet.us_east_us_east_1f_replication.id}"
#   depends_on    = [aws_internet_gateway.binary_dr_internet_gw]

#   tags = {
#     Name = "Binary DR NAT GW"
#   }
# }