resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_exec_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
#############################################
# CodeDeploy Role (ECS Blue/Green)
#############################################

resource "aws_iam_role" "codedeploy_role" {
  name = "CodeDeployECSRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "codedeploy.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

# REQUIRED POLICY (correct one)
resource "aws_iam_role_policy_attachment" "codedeploy_ecs_policy" {
  role       = aws_iam_role.codedeploy_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"
}

output "ecs_exec_role_arn" {
  value = aws_iam_role.ecs_task_execution_role.arn
}

output "codedeploy_role_arn" {
  value = aws_iam_role.codedeploy_role.arn
}