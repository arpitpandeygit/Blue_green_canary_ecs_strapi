resource "aws_lb" "app_alb" {
  name               = "${var.env}-alb"
  load_balancer_type = "application"
  subnets            = var.subnets
  security_groups    = [var.alb_sg]
}

resource "aws_lb_target_group" "blue" {
  name        = "${var.env}-blue"
  port        = 1337
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path = "/"
    port = "1337"
  }
}

resource "aws_lb_target_group" "green" {
  name        = "${var.env}-green"
  port        = 1337
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path = "/"
    port = "1337"
  }
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blue.arn
  }
}

#######################
# OUTPUTS
#######################

output "listener_arn" {
  value = aws_lb_listener.listener.arn
}

# ECS requires ARN
output "blue_tg_arn" {
  value = aws_lb_target_group.blue.arn
}

output "green_tg_arn" {
  value = aws_lb_target_group.green.arn
}

# CodeDeploy requires NAME
output "blue_tg_name" {
  value = aws_lb_target_group.blue.name
}

output "green_tg_name" {
  value = aws_lb_target_group.green.name
}

output "alb_dns" {
  value = aws_lb.app_alb.dns_name
}
