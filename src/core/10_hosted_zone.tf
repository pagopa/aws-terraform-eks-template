resource "aws_route53_zone" "env_eks_pagopa_it" {
  name = "${var.environment}.eks.pagopa.it"
}
