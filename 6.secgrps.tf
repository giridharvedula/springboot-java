# Security Group ECS
resource "aws_security_group" "ecs_sg" {
  name        = "sb-ecs-ecr-sg"
  description = "Allow ECS internal"
  vpc_id      = aws_vpc.main.id
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.128.0/20"]
    description = "sb-subnet-pvt-us-east-1a"
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.144.0/20"]
    description = "sb-subnet-pvt-us-east-1b"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "ECR to ECS Pull Images and other required services communicate"
  }
  tags = {
    Name = "sb-ecs-ecr-sg"
  }
  depends_on = [aws_vpc.main]
}

# Security Group Application Load Balancer
resource "aws_security_group" "alb_sg" {
  name        = "sb-alb-sg"
  description = "Load balancer sg - public traffic allowed"
  vpc_id      = aws_vpc.main.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP"
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPS"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }
  tags = {
    Name = "sb-alb-sg"
  }
  depends_on = [aws_vpc.main]
}
