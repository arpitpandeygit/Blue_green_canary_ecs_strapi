resource "aws_ecs_cluster" "cluster" {
  name = "${var.env}-cluster"
}

resource "aws_ecs_task_definition" "task" {
  family                   = "${var.env}-strapi"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu    = "512"
  memory = "1024"

  container_definitions = file("${path.module}/../../taskdef.json")

  execution_role_arn = var.execution_role
}

resource "aws_ecs_service" "service" {
  name            = "${var.env}-service"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  # 🔥 VERY IMPORTANT: let CodeDeploy manage deployments
  deployment_controller {
    type = "CODE_DEPLOY"
  }

  # 🔥 prevent Terraform from updating task revision directly
  lifecycle {
    ignore_changes = [task_definition]
  }

  network_configuration {
    subnets         = var.subnets
    security_groups = [var.ecs_sg]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.blue_tg_arn
    container_name   = "strapi"
    container_port   = 1337
  }
}

output "cluster_name" { value = aws_ecs_cluster.cluster.name }
output "service_name" { value = aws_ecs_service.service.name }
