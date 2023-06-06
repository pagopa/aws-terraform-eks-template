resource "aws_route53_zone" "eks_pagopa_it" {
  name = "${var.environment}.eks.pagopa.it"
}
