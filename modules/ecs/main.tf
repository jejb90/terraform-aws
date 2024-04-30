resource "aws_ecs_cluster" "cluster" {
  name = "ecs-cluster-${var.environment}"
}

resource "aws_ecr_repository" "app_repo" {
  name                 = "${var.service_name}-${var.environment}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

# Crear el rol de ejecución de ECS Task
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs-task-execution-role-${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        },
        Effect = "Allow",
        Sid    = ""
      }
    ]
  })
}

# Políticas para que el rol de ejecución pueda obtener imágenes de ECR y loggear en Cloudwatch
resource "aws_iam_role" "ecs_task_role" {
  name = "ecs-task-role-${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach a policy to the role. Modify or add more policies based on the specific needs of your tasks.
resource "aws_iam_role_policy_attachment" "task_execution_policy" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# se crea una plantilla default para el task definition
resource "aws_ecs_task_definition" "app_task" {
  family                   = "${var.service_name}-${var.environment}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  container_definitions    = jsonencode([
    {
      name        = "${var.service_name}-${var.environment}",
      image       = "springio/gs-spring-boot-docker",
      essential   = true,
      portMappings = [
        {
          containerPort = 80,
          hostPort      = null,
          protocol      = "tcp"
        }
      ],
      environment = [
        {
          name  = "JAVA_OPTS",
          value = "-Xms256m -Xmx512m"
        },
        {
          name  = "PORT",
          value = tostring(var.port_http)
        }
      ],
      cpu              = var.container_cpu,
      memoryReservation = var.container_memory
    }
  ])
  tags = {
    "Name" : "service-${var.service_name}-${var.environment}"
  }
}

# se crea el servicio
resource "aws_ecs_service" "app_service" {
  name            = "${var.service_name}-${var.environment}"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.app_task.arn
  desired_count   = var.desired_count
  enable_execute_command            = true
  launch_type     = "FARGATE"

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "${var.service_name}-${var.environment}"
    container_port   = var.port_http
  }

  network_configuration {
    subnets         = var.subnets
    security_groups = [var.security_group_id]
    assign_public_ip = true
  }
}

resource "aws_appautoscaling_target" "ecs_target" {
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.cluster.id}/${aws_ecs_service.app_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  min_capacity       = var.min_capacity
  max_capacity       = var.max_capacity
}


# politicas de escalado
resource "aws_appautoscaling_policy" "scale_out" {
  name               = "${var.service_name}-scale-out"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  policy_type        = "StepScaling"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 300
    metric_aggregation_type = "Average"
    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = 1
    }
  }
}

resource "aws_appautoscaling_policy" "scale_in" {
  name               = "${var.service_name}-scale-in"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  policy_type        = "StepScaling"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 300
    metric_aggregation_type = "Average"
    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = -1
    }
  }
}


