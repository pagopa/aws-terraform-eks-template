resource "kubernetes_namespace" "log" {
  metadata {
    name = "aws-observability"

    labels = {
      aws-observability = "enabled"
    }
  }
}

resource "kubernetes_config_map" "log" {
  metadata {
    name      = "aws-logging"
    namespace = kubernetes_namespace.log.id
  }

  data = {
    flb_log_cw     = "true"
    "output.conf"  = <<-EOT
      [OUTPUT]
        Name cloudwatch_logs
        Match kube.*
        region ${var.aws_region}
        log_group_name /dvopla-d/fargate-fluentbit-logs
        log_stream_prefix fargate-logs-
        auto_create_group true
    EOT
    "filters.conf" = <<-EOF
      [FILTER]
        Name parser
        Match *
        Key_Name log
        Parser regex
      [FILTER]
        Name kubernetes
        Match kube.*
        Merge_Log On
        Keep_Log Off
        Buffer_Size 0
        Kube_Meta_Cache_TTL 300s
    EOF
    "parsers.conf" = <<-EOF
      [PARSER]
        Name regex
        Format regex
        Regex ^(?<time>[^ ]+) (?<stream>stdout|stderr) (?<logtag>P|F) (?<log>.*)$
        Time_Key time
        Time_Format %Y-%m-%dT%H:%M:%S.%L%z
    EOF
  }
}

resource "aws_iam_policy" "log" {
  name        = "eks-fargate-logging-access"
  path        = "/"
  description = "Enable Fargate FluentBit to export logs into CloudWatch"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogStream",
          "logs:CreateLogGroup",
          "logs:DescribeLogStreams",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "log" {
  for_each = module.eks.fargate_profiles

  role       = each.value.iam_role_name
  policy_arn = aws_iam_policy.log.arn
}
