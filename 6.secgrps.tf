# Security Group ECS
resource "aws_security_group" "ecs_sg" {
  name        = "sb-java-ecs-sg"
  description = "Allow ECS internal"
  vpc_id      = aws_vpc.main.id
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [
      "10.0.128.0/20",
      "10.0.144.0/20",
      "0.0.0.0/0"
    ]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "sb-java-ecs-sg"
  }
}

# Security Group Application Load Balancer
resource "aws_security_group" "alb_sg" {
  name        = "sb-java-alb-sg"
  description = "Load balancer sg - public traffic allowed"
  vpc_id      = aws_vpc.main.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "sb-java-alb-sg"
  }
}
