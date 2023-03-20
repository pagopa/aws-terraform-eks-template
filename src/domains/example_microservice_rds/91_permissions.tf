resource "aws_iam_role_policy_attachment" "backup_executor_permissions" {
  role       = aws_iam_role.backup_executor.name
  policy_arn = aws_iam_policy.backup_access.arn
}
