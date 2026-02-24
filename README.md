# Blue-Green Canary Deployment (AWS ECS Fargate + CodeDeploy)

This project demonstrates production-grade deployment using:

✅ ECS Fargate  
✅ Blue/Green deployments  
✅ CodeDeploy Canary strategy  
✅ Application Load Balancer  
✅ Terraform Infrastructure as Code  
✅ Docker & ECR  

## Deployment Strategy

CodeDeployDefault.ECSCanary10Percent5Minutes

## Architecture

ALB → Target Groups (Blue/Green) → ECS Tasks → Strapi Container

## Run

terraform init  
terraform apply  

## Trigger Deployment

aws deploy create-deployment --cli-input-json file://revision.json
