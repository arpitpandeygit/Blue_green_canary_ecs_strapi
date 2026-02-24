provider "aws" {
  region = "us-east-1"
}

module "network" {
  source = "../../modules/networking"
}

module "security" {
  source = "../../modules/security"
  vpc_id = module.network.vpc_id
  env    = "dev"
}

module "alb" {
  source  = "../../modules/alb"
  env     = "dev"
  vpc_id  = module.network.vpc_id
  subnets = module.network.subnets
  alb_sg  = module.security.alb_sg
}

module "ecs" {
  source  = "../../modules/ecs"
  env     = "dev"
  subnets = module.network.subnets
  ecs_sg  = module.security.ecs_sg

  # ECS requires TARGET GROUP ARN
  blue_tg_arn   = module.alb.blue_tg_arn
  execution_role = "arn:aws:iam::312504613160:role/ecsTaskExecutionRole"
}

module "codedeploy" {
  source = "../../modules/codedeploy"
  env    = "dev"

  cluster = module.ecs.cluster_name
  service = module.ecs.service_name

  # CodeDeploy requires TARGET GROUP NAMES
  blue_tg  = module.alb.blue_tg_name
  green_tg = module.alb.green_tg_name

  listener = module.alb.listener_arn

  codedeploy_role = "arn:aws:iam::312504613160:role/CodeDeployECSRole"
}

output "alb_dns" {
  value = module.alb.alb_dns
}
