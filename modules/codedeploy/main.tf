resource "aws_codedeploy_app" "ecs_app" {
  name             = "${var.env}-codedeploy"
  compute_platform = "ECS"
}

resource "aws_codedeploy_deployment_group" "dg" {
  app_name              = aws_codedeploy_app.ecs_app.name
  deployment_group_name = "${var.env}-dg"
  service_role_arn      = var.codedeploy_role

  deployment_config_name = "CodeDeployDefault.ECSCanary10Percent5Minutes"

  # REQUIRED for ECS blue/green
  deployment_style {
    deployment_type   = "BLUE_GREEN"
    deployment_option = "WITH_TRAFFIC_CONTROL"
  }

  ecs_service {
    cluster_name = var.cluster
    service_name = var.service
  }

  load_balancer_info {
    target_group_pair_info {
      target_group {
        name = var.blue_tg
      }

      target_group {
        name = var.green_tg
      }

      prod_traffic_route {
        listener_arns = [var.listener]
      }
    }
  }

  blue_green_deployment_config {

    # 🔥 REQUIRED (missing piece)
    deployment_ready_option {
      action_on_timeout    = "CONTINUE_DEPLOYMENT"
      wait_time_in_minutes = 0
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 5
    }
  }

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }
}
