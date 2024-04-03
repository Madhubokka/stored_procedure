output "storage_user_arn" {
  value = snowflake_storage_integration.dpa_integration.storage_aws_iam_user_arn
}

output "storage_external_id" {
  value = snowflake_storage_integration.dpa_integration.storage_aws_external_id
}

output "storage_integration_name" {
  value = snowflake_storage_integration.dpa_integration.name
}

output "storage_integraton" {
  value = snowflake_storage_integration.dpa_integration
}
