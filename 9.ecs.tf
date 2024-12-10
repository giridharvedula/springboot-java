# ECS Cluster
resource "aws_ecs_cluster" "app_test" {
  name = "sb-app-cluster"
  tags = {
    Name = "sb-app-cluster"
  }
  depends_on = [ aws_ecr_repository.frontend, aws_ecr_repository.backend ]
}

# ECS Frontend Task Definition
resource "aws_ecs_task_definition" "frontend_task" {
  family                   = "sb-frontend-task"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "1024"
  container_definitions    = jsonencode([{
    name      = "frontend-container"
    image     = "578133268609.dkr.ecr.us-east-1.amazonaws.com/sb-java-ecr-repo-frontend:latest"
    cpu       = 256
    memory    = 512
    essential = true
    portMappings = [{
      containerPort = 80
      protocol      = "tcp"
    }]
  }])
  tags = {
    Name = "sb-frontend-task"
  }
  depends_on = [ aws_ecr_repository.frontend ]
}

# ECS Backend Task Definition
resource "aws_ecs_task_definition" "backend_task" {
  family                   = "sb-backend-task"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "1024"
  container_definitions    = jsonencode([{
    name      = "backend-container"
    image     = "578133268609.dkr.ecr.us-east-1.amazonaws.com/sb-java-ecr-repo-backend:latest"
    cpu       = 256
    memory    = 512
    essential = true
    portMappings = [{
      containerPort = 80
      protocol      = "tcp"
    }]
  }])
  tags = {
    Name = "sb-backend-task"
  }
  depends_on = [ aws_ecr_repository.backend ]
}

# ECS Service Frontend
resource "aws_ecs_service" "frontend_service" {
  name            = "sb-frontend-service"
  cluster         = aws_ecs_cluster.app_test.id
  task_definition = aws_ecs_task_definition.frontend_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  network_configuration {
    subnets          = [aws_subnet.private1_us_east_1a.id, aws_subnet.private2_us_east_1b.id]
    security_groups = [aws_security_group.ecs_sg.id]
    assign_public_ip = false
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.frontend_tg.arn
    container_name   = "frontend-container"
    container_port   = 80
  }
  depends_on = [ aws_ecs_task_definition.frontend_task ]
  tags = {
    Name = "sb-frontend-service"
  }
}

# ECS Service Backend
resource "aws_ecs_service" "backend_service" {
  name            = "sb-backend-service"
  cluster         = aws_ecs_cluster.app_test.id
  task_definition = aws_ecs_task_definition.backend_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  network_configuration {
    subnets          = [aws_subnet.private1_us_east_1a.id, aws_subnet.private2_us_east_1b.id]
    security_groups = [aws_security_group.ecs_sg.id]
    assign_public_ip = false
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.frontend_tg.arn
    container_name   = "backend-container"
    container_port   = 80
  }
  depends_on = [ aws_ecs_task_definition.frontend_task ]
  tags = {
    Name = "sb-backend-service"
  }
}
