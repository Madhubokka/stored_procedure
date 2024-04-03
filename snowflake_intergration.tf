

# resource "snowflake_storage_integration" "dpa_integration" {
#   type                      = "EXTERNAL_STAGE"
#   storage_provider          = "S3"
#   enabled                   = true
#   storage_aws_role_arn      = var.custom_aws_role_arn
#   name                      = "dpa_snowflake_storage_integration-${var.database_name}"
#   comment                   = "A storage integration."
#   storage_allowed_locations = ["${var.s3_bucket_url}/"]
# }
