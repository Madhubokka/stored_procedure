output "s3_bucket_name" {
  value       = aws_s3_bucket.data-analytics-s3-main-bucket.bucket
  description = "ID of the bucket holding the lambda functions."
}

output "s3_bucket_id" {
  value       = aws_s3_bucket.data-analytics-s3-main-bucket.id
  description = "ID of the bucket holding the lambda functions."
}

output "s3_bucket_arn" {
  value       = aws_s3_bucket.data-analytics-s3-main-bucket.arn
  description = "ID of the bucket holding the lambda functions."
}

# output "s3_bucket_website_endpoint" {
#   value = aws_s3_bucket.data-analytics-s3-main-bucket.website_endpoint
# }
