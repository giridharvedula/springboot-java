# Route Table for Public Subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "rtb-public"
  }
  route = [ {
    gateway_id = "aws_internet_gateway.gw.id",
    cidr_block = "0.0.0.0/0"
  } ]
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
