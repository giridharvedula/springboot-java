# Route Table for Public Subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route = [
    {
      cidr_block = "0.0.0.0/0",
      gateway_id = aws_internet_gateway.gw.id,
      carrier_gateway_id = null,
      core_network_arn = null,
      destination_prefix_list_id = null,
      egress_only_gateway_id = null,
      ipv6_cidr_block = null,
      local_gateway_id = null,
      nat_gateway_id = null,
      network_interface_id = null,
      transit_gateway_id = null,
      vpc_endpoint_id = null,
      vpc_peering_connection_id = null
    }
  ]
  tags = {
    Name = "rtb-public"
  }
}

# Associate the public subnets with the public route table
resource "aws_route_table_association" "public_association_1" {
  subnet_id      = aws_subnet.public1_us_east_1a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_association_2" {
  subnet_id      = aws_subnet.public2_us_east_1b.id
  route_table_id = aws_route_table.public.id
}

# Route Table for Private Subnet 1 (us-east-1a)
resource "aws_route_table" "private1_us_east_1a" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "rtb-private1-us-east-1a"
  }
}

# Associate the private subnet 1 with its route table
resource "aws_route_table_association" "private1_association" {
  subnet_id      = aws_subnet.private1_us_east_1a.id
  route_table_id = aws_route_table.private1_us_east_1a.id
}

# Route Table for Private Subnet 2 (us-east-1b)
resource "aws_route_table" "private2_us_east_1b" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "rtb-private2-us-east-1b"
  }
}

# Associate the private subnet 2 with its route table
resource "aws_route_table_association" "private2_association" {
  subnet_id      = aws_subnet.private2_us_east_1b.id
  route_table_id = aws_route_table.private2_us_east_1b.id
}
