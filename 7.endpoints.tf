# S3 Gateway Endpoint
resource "aws_vpc_endpoint" "s3" {
  vpc_id = aws_vpc.main.id
  service_name = "com.amazonaws.us-east-1.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids = [
    aws_route_table.private1_us_east_1a.id,
    aws_route_table.private2_us_east_1b.id
  ]
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "s3:*"
        "Principal": {
          "AWS": "*"
        }
        Resource = "*"
      }
    ]
  })
  tags = {
    Name = "sb-java-s3-endpoint"
  }
}

# ECR Serverless Endpoints
resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id = aws_vpc.main.id
  service_name = "com.amazonaws.us-east-1.ecr.api"
  vpc_endpoint_type = "Interface"
  subnet_ids = [
    aws_subnet.private1_us_east_1a.id,
    aws_subnet.private2_us_east_1b.id
  ]
  security_group_ids = [aws_security_group.ecs_sg.id]
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "ecr:*"
        Resource = "*"
        "Principal": {
          "AWS": "*"
        }
      }
    ]
  })
  tags = {
    Name = "sb-java-ecr-api-endpoint"
  }
}

resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id = aws_vpc.main.id
  service_name = "com.amazonaws.us-east-1.ecr.dkr"
  vpc_endpoint_type = "Interface"
  subnet_ids = [
    aws_subnet.private1_us_east_1a.id,
    aws_subnet.private2_us_east_1b.id
  ]
  security_group_ids = [aws_security_group.ecs_sg.id]
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "ecr:*"
        Resource = "*"
        "Principal": {
          "AWS": "*"
        }
      }
    ]
  })
  tags = {
    Name = "sb-java-ecr-dkr-endpoint"
  }
}
