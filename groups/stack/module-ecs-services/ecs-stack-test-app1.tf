locals {
  test1_service_name = "ecs-stack-test-app1"
}


resource "aws_ecs_service" "ecs-stack-test-app1-ecs-service" {
  name            = "${var.environment}-${local.test1_service_name}"
  cluster         = var.ecs_cluster_id
  task_definition = aws_ecs_task_definition.ecs-stack-test-app1-task-definition.arn
  desired_count   = 1
  depends_on      = [var.test-data-lb-arn]
  launch_type = "FARGATE"
  load_balancer {
    target_group_arn = aws_lb_target_group.ecs-stack-test-app1-target_group.arn
    container_port   = var.test1_application_port
    container_name   = "${local.test1_service_name}"
  }
}

locals {
  ecs-stack-test-app1-definition = merge(
    {
      environment                     : var.environment
      name_prefix                     : var.name_prefix
      aws_region                      : var.aws_region
      external_top_level_domain       : var.external_top_level_domain
      log_level                       : var.log_level
      docker_registry                 : var.docker_registry
      release_version                 : var.test1_release_version
      application_port                : var.test1_application_port
    },
      var.secrets_arn_map
  )
}

resource "aws_ecs_task_definition" "ecs-stack-test-app1-task-definition" {
  family             = "${var.environment}-${local.test1_service_name}"
  execution_role_arn = var.task_execution_role_arn
  requires_compatibilities = ["FARGATE"]
  network_mode = "awsvpc"
  container_definitions = templatefile(
    "${path.module}/${local.test1_service_name}-task-definition.tmpl", local.ecs-stack-test-app1-definition
  )
}

resource "aws_lb_target_group" "ecs-stack-test-app1-target_group" {
  name     = "${var.environment}-${local.test1_service_name}-tg"
  port     = var.test1_application_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type = "ip"

  health_check {
    healthy_threshold   = "5"
    unhealthy_threshold = "2"
    interval            = "30"
    matcher             = "200"
    path                = "/test1/healthcheck"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = "5"
  }
}

resource "aws_lb_listener_rule" "ecs-stack-test-app1" {
  listener_arn = var.test-data-lb-listener-arn
  priority     = 3
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs-stack-test-app1-target_group.arn
  }
  condition {
    field  = "path-pattern"
    values = ["/test1/*"]
  }
}
