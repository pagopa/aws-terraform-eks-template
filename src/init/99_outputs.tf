output "backend_bucket_name" {
  value = aws_s3_bucket.terraform_states.bucket
}

output "dynamodb_lock_table" {
  value = aws_dynamodb_table.dynamodb_terraform_state_lock.name
}

output "iac_role_arn" {
  value       = aws_iam_role.githubiac.arn
  description = "Role to use in github actions to build the infrastructure."
}
