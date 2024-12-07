# ECS Cluster
resource "aws_ecs_cluster" "app_test" {
  name = "sb-java-app-cluster"
  tags = {
    Name = "sb-java-app-cluster"
  }
}

# ECS Frontend Task Definition
resource "aws_ecs_task_definition" "frontend_task" {
  family                   = "sb-java-frontend-task"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "1024"
  container_definitions    = jsonencode([{
    name      = "frontend-container"
    image     = "public.ecr.aws/ecs-sample-image/amazon-ecs-sample:latest"
    cpu       = 256
    memory    = 512
    essential = true
    portMappings = [{
      containerPort = 80
      protocol      = "tcp"
    }]
  }])
  tags = {
    Name = "sb-java-frontend-task"
  }
}

# ECS Backend Task Definition
resource "aws_ecs_task_definition" "backend_task" {
  family                   = "sb-java-backend-task"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "1024"
  container_definitions    = jsonencode([{
    name      = "sb-java-backend-container"
    image     = "public.ecr.aws/ecs-sample-image/amazon-ecs-sample:latest"
    cpu       = 256
    memory    = 512
    essential = true
    portMappings = [{
      containerPort = 80
      protocol      = "tcp"
    }]
  }])
  tags = {
    Name = "sb-java-backend-task"
  }
}

# ECS Service Frontend
resource "aws_ecs_service" "frontend_service" {
  name            = "sb-java-frontend-service"
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
    container_name   = "sb-java-frontend-container"
    container_port   = 80
  }
  depends_on = [ aws_ecs_task_definition.frontend_task ]
  tags = {
    Name = "sb-java-frontend-service"
  }
}

# ECS Service Backend
resource "aws_ecs_service" "backend_service" {
  name            = "sb-java-backend-service"
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
    container_name   = "sb-java-backend-container"
    container_port   = 80
  }
  depends_on = [ aws_ecs_task_definition.frontend_task ]
  tags = {
    Name = "sb-java-backend-service"
  }
}
