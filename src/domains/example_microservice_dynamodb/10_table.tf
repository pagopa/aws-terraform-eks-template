resource "aws_dynamodb_table" "entries" {
  name           = "${local.project}-entries"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "Type"

  attribute {
    name = "Type"
    type = "S"
  }
}
