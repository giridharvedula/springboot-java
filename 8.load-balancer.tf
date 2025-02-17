
# Target Group Frontend
resource "aws_lb_target_group" "frontend_tg" {
  name        = "sb-frontend-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.main.id
  health_check {
    protocol = "HTTPS"
    path     = "/"
  }
  tags = {
    Name = "sb-frontend-tg"
  }
  depends_on = [ aws_vpc.main ]
}

# Target Group Backend
resource "aws_lb_target_group" "backend_tg" {
  name        = "sb-backend-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.main.id
  health_check {
    protocol = "HTTPS"
    path     = "/"
  }
  tags = {
    Name = "sb-backend-tg"
  }
  depends_on = [ aws_lb_target_group.frontend_tg ]
}

# Load Balancer - Scheme
resource "aws_lb" "app_alb" {
  name               = "sb-app-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [
    aws_subnet.public1_us_east_1a.id,
    aws_subnet.public2_us_east_1b.id
  ]
  enable_deletion_protection = false
  tags = {
    Name = "sb-app-alb"
  }
}

# Load Balancer Listeners
# resource "aws_lb_listener" "http_listener" {
#  load_balancer_arn = aws_lb.app_alb.arn
#  port              = 80
#  protocol          = "HTTP"
#  default_action {
#    type             = "redirect"
#    redirect {
#      protocol = "HTTPS"
#      port     = "443"
#      status_code = "HTTP_301"
#    }
#  }
#}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.app_alb.arn
#  port              = 443
   port              = 80
#  protocol          = "HTTPS"
   protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend_tg.arn
  }
  tags = {
    Name = "sb-http-listener"
  }
  depends_on = [ aws_lb.app_alb ]
}
