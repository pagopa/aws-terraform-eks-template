output "vpc_id" {
  description = "Id of the current VPC"
  value       = module.vpc.vpc_id
}

output "public_subnets_ids" {
  description = "Id list of the public subnets"
  value       = module.vpc.public_subnets
}

output "nat_ids" {
  description = "Id list of the NAT gatways"
  value       = aws_nat_gateway.this[*].id
}

output "nat_eips" {
  description = "EIP list of the NAT gatways"
  value       = aws_eip.nat[*].public_ip
}

output "hosted_zone_id_env_eks_pagopa_it" {
  description = "<env>.eks.pagopa.it hosted zone id"
  value       = aws_route53_zone.env_eks_pagopa_it.zone_id
}

output "ns_env_eks_pagopa_it" {
  description = "NS for <env>.eks.pagopa.it"
  value       = aws_route53_zone.env_eks_pagopa_it.name_servers
}
