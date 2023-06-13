output "backend_bucket_name" {
  value = aws_s3_bucket.terraform_states.bucket
}

output "dynamodb_lock_table" {
  value = aws_dynamodb_table.dynamodb_terraform_state_lock.name
}

output "iac_admin_role_arn" {
  value       = aws_iam_role.githubiac["Admin"].arn
  description = "Role to use in github actions to build the infrastructure."
}

output "iac_admin_ro_arn" {
  value       = aws_iam_role.githubiac["ReadOnly"].arn
  description = "Role to use in github actions to read over the infrastructure."
}

output "iac_admin_ecsrunner_arn" {
  value       = aws_iam_role.githubiac["ECSRunner"].arn
  description = "Role to use in github actions to manage ECS."
}
