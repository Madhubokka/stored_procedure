locals {
  account_id          = data.aws_caller_identity.current.account_id
  partition           = data.aws_partition.current.partition
  role_name_condition = var.role_name != null ? var.role_name : "${var.role_name_prefix}*"
}


resource "aws_iam_role" "dpa-snowflake-s3-storage-access-role" {
  name = var.role_name
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [{
      "Effect" : "Allow",
      "Principal" : {
        "Service" : "s3.amazonaws.com"
      },
      "Action" : "sts:AssumeRole",
      "Sid" : ""
    }]
  })
}


# S3 bucket iam policy
resource "aws_iam_policy" "dpa-snowflake-s3-storage-access-policy" {
  name        = "${var.role_name}-policy"
  description = "aws s3 access policy for snowflake"
  policy      = data.aws_iam_policy_document.dpa-snowflake-s3-storage-access-policy-document.json
}


# Attach the IAM policy to the IAM role
resource "aws_iam_role_policy_attachment" "dpa-snowflake-storage-policy-attachment" {
  role       = aws_iam_role.dpa-snowflake-s3-storage-access-role.name
  policy_arn = aws_iam_policy.dpa-snowflake-s3-storage-access-policy.arn
}


# resource "aws_iam_role" "dpa-snowflake-s3-storage-access-role" {
#   #count = length(var.dpa_snowflake_iam_role_name)
#   #depends_on = [snowflake_storage_integration.dpa_integration]
#   name = var.dpa_snowflake_iam_role_name
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Sid    = ""
#         Principal = {
#           "AWS" : "*"
#           #AWS = module.dpa_poc_snowflake.storage_user_arn
#         }
#         Condition = {
#           "StringEquals" : {
#             "sts:ExternalId" : "*"
#             #"sts:ExternalId" = module.dpa_poc_snowflake.storage_external_id
#           }
#         }
#       },
#     ]
#   })
# }


# # resource "aws_iam_role" "dpa-snowflake-s3-storage-access-role" {
# #   #   #count = length(var.warehouse_name)
# #   #   #depends_on = [module.dpa_poc_snowflake]
# #   name               = "${var.project_name}-${var.env}-s3-access-role"
# #   assume_role_policy = data.aws_iam_policy_document.dpa_snowflake_role_policy.json
# # }


# resource "aws_iam_policy" "dpa-snowflake-s3-storage-access-policy" {
#   #count       = length(var.dpa_snowflake_iam_role_name)
#   name        = "${var.dpa_snowflake_iam_role_name}-policy"
#   description = "Allow read and write access to s3 bucket"
#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         "Effect" : "Allow",
#         "Action" : [
#           "s3:Getobject", "s3:ListBucket", "s3:PutObject*", "s3:PutObjectTagging"
#         ],
#         Resource = ["arn:aws:s3:::${var.dpa_s3_bucket_name}", "arn:aws:s3:::${var.dpa_s3_bucket_name}/*"]
#       }
#     ]
#     Statement = [
#       {
#         "Effect" : "Allow",
#         "Action" : [
#           "kms:Encrypt",
#           "kms:Decrypt",
#           "kms:ReEncrypt*",
#           "kms:GenerateDataKey*",
#           "kms:DescribeKey"
#         ],
#         Resource = ["arn:aws:s3:::${var.dpa_s3_bucket_name}", "arn:aws:s3:::${var.dpa_s3_bucket_name}/*"]
#       }
#     ]
#   })
# }

# resource "aws_iam_role_policy_attachment" "dpa-snowflake-storage-policy-attachment" {
#   #count      = length(var.dpa_snowflake_iam_role_name)
#   role       = aws_iam_role.dpa-snowflake-s3-storage-access-role.id
#   policy_arn = aws_iam_policy.dpa-snowflake-s3-storage-access-policy.arn
# }
