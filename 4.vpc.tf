# VPC Creation
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "sb-vpc"
  }
  depends_on = [ data.aws_availability_zones.available ]
}

# Subnets in two available zones
resource "aws_subnet" "private1_us_east_1a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.128.0/20"
  availability_zone = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = false
  tags = {
    Name = "sb-subnet-pvt-us-east-1a"
  }
  depends_on = [ aws_vpc.main ]
}

resource "aws_subnet" "private2_us_east_1b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.144.0/20"
  availability_zone = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = false
  tags = {
    Name = "sb-subnet-pvt-us-east-1b"
  }
  depends_on = [ aws_vpc.main ]
}

resource "aws_subnet" "public1_us_east_1a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.0.0/20"
  availability_zone = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true
  tags = {
    Name = "sb-subnet-pub-us-east-1a"
  }
  depends_on = [ aws_vpc.main ]
}

resource "aws_subnet" "public2_us_east_1b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.16.0/20"
  availability_zone = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true
  tags = {
    Name = "sb-subnet-pub-us-east-1b"
  }
  depends_on = [ aws_vpc.main ]
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "sb-igw"
  }
  depends_on = [ aws_vpc.main ]
}
