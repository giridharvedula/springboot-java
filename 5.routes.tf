# Route Table for Public Subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route = [
    {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.gw.id
      carrier_gateway_id = null
      core_network_arn = null
      destination_prefix_list_id = null
      egress_only_gateway_id = null
      ipv6_cidr_block = null
      local_gateway_id = null
      nat_gateway_id = null
      network_interface_id = null
      transit_gateway_id = null
      vpc_endpoint_id = null
      vpc_peering_connection_id = null
    },
    {
      cidr_block = "10.0.0.0/16"
      local_gateway_id = "local"
      gateway_id = null
      destination_prefix_list_id = null
      carrier_gateway_id = null
      core_network_arn = null
      egress_only_gateway_id = null
      ipv6_cidr_block = null
      network_interface_id = null
      transit_gateway_id = null
      vpc_endpoint_id = null
      vpc_peering_connection_id = null
      nat_gateway_id = null
    }
  ]
  tags = {
    Name = "sb-java-rtb-public"
  }
  depends_on = [ aws_internet_gateway.gw ]
}

# Associate the public subnets with the public route table
resource "aws_route_table_association" "public_association_1" {
  subnet_id      = aws_subnet.public1_us_east_1a.id
  route_table_id = aws_route_table.public.id
  depends_on = [ aws_subnet.public1_us_east_1a ]
}

resource "aws_route_table_association" "public_association_2" {
  subnet_id      = aws_subnet.public2_us_east_1b.id
  route_table_id = aws_route_table.public.id
  depends_on = [ aws_subnet.public2_us_east_1b ]
}

# Route Table for Private Subnet 1 (us-east-1a)
resource "aws_route_table" "private1_us_east_1a" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "sb-java-rtb-pvt-us-east-1a"
  }
  depends_on = [ aws_vpc.main ]
}

# Associate the private subnet 1 with its route table
resource "aws_route_table_association" "private1_association" {
  subnet_id      = aws_subnet.private1_us_east_1a.id
  route_table_id = aws_route_table.private1_us_east_1a.id
  depends_on = [ aws_subnet.private1_us_east_1a ]
}

# Route Table for Private Subnet 2 (us-east-1b)
resource "aws_route_table" "private2_us_east_1b" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "sb-java-rtb-pvt-us-east-1b"
  }
  depends_on = [ aws_vpc.main ]
}

# Associate the private subnet 2 with its route table
resource "aws_route_table_association" "private2_association" {
  subnet_id      = aws_subnet.private2_us_east_1b.id
  route_table_id = aws_route_table.private2_us_east_1b.id
  depends_on = [ aws_subnet.private2_us_east_1b ]
}
