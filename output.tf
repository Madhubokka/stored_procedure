
output "s3_bucket_id" {
  description = "Bucket name"
  value       = module.dpa_poc_bucket[0].s3_bucket_id
}

output "s3_bucket_name" {
  description = "Bucket name"
  value       = module.dpa_poc_bucket[0].s3_bucket_name
}


output "s3_bucket_arn" {
  description = "Bucket name"
  value       = module.dpa_poc_bucket[0].s3_bucket_arn
}


output "kms_key_arn" {
  value = aws_kms_key.dpa-kms-for-s3.arn
}

output "kma_key_id" {
  value = aws_kms_key.dpa-kms-for-s3.key_id
}


output "storage_user_arn" {
  value = join(",", module.dpa_poc_snowflake.*.storage_user_arn)
}

output "storage_external_id" {
  value = join(",", module.dpa_poc_snowflake.*.storage_external_id)
}

output "storage_integration_name" {
  value = join(",", module.dpa_poc_snowflake.*.storage_integration_name)
}


output "snowflake_role_name" {
  value = module.dpa_poc_iam.*.snowflake_role_name

}
