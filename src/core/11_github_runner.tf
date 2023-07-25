data "aws_iam_policy" "ecs_task_exec" {
  name = "AmazonECSTaskExecutionRolePolicy"
}

data "aws_iam_policy_document" "ecs_tasks_assume" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "ecs_tasks_assume_condition" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = ["arn:aws:ecs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:*"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }
  }
}

resource "aws_iam_role" "github_runner_task_exec" {
  name = "${local.project}-github-runner-exec"

  assume_role_policy  = data.aws_iam_policy_document.ecs_tasks_assume.json
  managed_policy_arns = toset([data.aws_iam_policy.ecs_task_exec.arn])

  inline_policy {
    name = "CreateLogGroup"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect   = "Allow"
          Action   = "logs:CreateLogGroup"
          Resource = "*"
        }
      ]
    })
  }
}

resource "aws_iam_role" "github_runner_task" {
  name = "${local.project}-github-runner-task"

  assume_role_policy = data.aws_iam_policy_document.ecs_tasks_assume_condition.json

  inline_policy {
    name = "KubeConfigPolicy"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect   = "Allow"
          Action   = "eks:DescribeCluster"
          Resource = "*"
        }
      ]
    })
  }

  inline_policy {
    name = "SecretsAccessPolicy"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect   = "Allow"
          Action   = "secretsmanager:GetSecretValue"
          Resource = "*"
        }
      ]
    })
  }

  inline_policy {
    name = "ReadImagesPolicy"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Action = [
            "ecr:GetAuthorizationToken",
            "ecr:BatchGetImage"
          ]
          Resource = "*"
        }
      ]
    })
  }
}

resource "aws_ecs_cluster" "github_runners" {
  name = "${local.project}-github-runners"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_cluster_capacity_providers" "fargate" {
  cluster_name = aws_ecs_cluster.github_runners.name

  capacity_providers = ["FARGATE"]
}

resource "aws_ecs_task_definition" "github_runner" {
  family = "${local.project}-github-runner"

  cpu                = var.github_runners.cpu
  memory             = var.github_runners.memory
  network_mode       = "awsvpc"
  execution_role_arn = aws_iam_role.github_runner_task_exec.arn
  task_role_arn      = aws_iam_role.github_runner_task.arn

  container_definitions = jsonencode([
    {
      name      = "github-runner"
      cpu       = var.github_runners.cpu
      memory    = var.github_runners.memory
      essential = true
      image     = var.github_runners.image_uri

      portMappngs = [
        {
          containerPort = 443
          hostPort      = 443
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-region        = var.aws_region
          awslogs-group         = "/aws/ecs"
          awslogs-stream-prefix = "github-runners"
          awslogs-create-group  = "true"
        }
      }
    }
  ])
}

#tfsec:ignore:aws-ec2-no-public-egress-sgr
resource "aws_security_group" "github_runners" {
  description = "SG for Github runners"
  vpc_id      = module.vpc.vpc_id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
