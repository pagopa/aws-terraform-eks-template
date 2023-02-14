resource "aws_wafv2_web_acl" "this" {
  name     = local.project
  scope    = "REGIONAL"

  default_action {
    allow {} # allow or block
  }

  visibility_config {
    cloudwatch_metrics_enabled = var.api_create_waf_metrics
    sampled_requests_enabled   = var.api_sample_waf_requests
    metric_name                = "${local.project}-waf-metrics"
  }

  rule {
    name     = "AWSManagedRulesCommonRuleSet"
    priority = 1
    override_action {
      none {}
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = var.api_create_waf_metrics
      sampled_requests_enabled   = var.api_sample_waf_requests
      metric_name                = "${local.project}-waf-metrics"
    }
  }

  rule {
    name     = "AWSManagedRulesSQLiRuleSet"
    priority = 2
    override_action {
      none {}
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesSQLiRuleSet"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = var.api_create_waf_metrics
      sampled_requests_enabled   = var.api_sample_waf_requests
      metric_name                = "${local.project}-waf-metrics"
    }
  }

  rule {
    name     = "AWSManagedRulesKnownBadInputsRuleSet"
    priority = 3
    override_action {
      none {}
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = var.api_create_waf_metrics
      sampled_requests_enabled   = var.api_sample_waf_requests
      metric_name                = "${local.project}-waf-metrics"
    }
  }

  rule {
    name     = "AWSManagedRulesAmazonIpReputationList"
    priority = 4
    override_action {
      none {}
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAmazonIpReputationList"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = var.api_create_waf_metrics
      sampled_requests_enabled   = var.api_sample_waf_requests
      metric_name                = "${local.project}-waf-metrics"
    }
  }

  rule {
    name     = "AWSManagedRulesBotControlRuleSet"
    priority = 5
    override_action {
      none {}
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesBotControlRuleSet"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = var.api_create_waf_metrics
      sampled_requests_enabled   = var.api_sample_waf_requests
      metric_name                = "${local.project}-waf-metrics"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}
