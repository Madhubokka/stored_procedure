# S3 bucket iam role
resource "aws_iam_role" "data-analytics-s3-s3-write-access-role" {
  name = "${var.project_name}-${var.env}-write-access-iam-role"
  path = "/service-role/"
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
resource "aws_iam_policy" "data-analytics-s3-write-access-policy" {
  name        = "data-analytics-s3-write-access-policy"
  description = "write access to s3"
  policy      = data.aws_iam_policy_document.data-analytics-s3-write-access-policy-doc.json
}


# Attach the IAM policy to the IAM role
resource "aws_iam_role_policy_attachment" "data-analytics-s3-s3-write-access-policy-attachment" {
  role       = aws_iam_role.data-analytics-s3-s3-write-access-role.name
  policy_arn = aws_iam_policy.data-analytics-s3-write-access-policy.arn
}

# S3 bucket iam role
resource "aws_iam_role" "data-analytics-s3-s3-read-access-role" {
  name = "${var.project_name}-${var.env}-read-access-iam-role"
  path = "/service-role/"
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
resource "aws_iam_policy" "data-analytics-s3-read-access-policy" {
  name        = "data-analytics-s3-read-access-policy"
  description = "read access to s3"
  policy      = data.aws_iam_policy_document.data-analytics-s3-read-access-policy-doc.json
}


# Attach the IAM policy to the IAM role
resource "aws_iam_role_policy_attachment" "data-analytics-s3-s3-read-access-policy-attachment" {
  role       = aws_iam_role.data-analytics-s3-s3-read-access-role.name
  policy_arn = aws_iam_policy.data-analytics-s3-read-access-policy.arn
}


# resource "aws_iam_role" "dpa-snowflake-s3-storage-access-role" {
#   #count = length(var.warehouse_name)
#   name = "${var.project_name}-${var.env}-s3-access-role"
#   path = "/service-role/"
#   assume_role_policy = jsonencode({
#     "Version" : "2012-10-17",
#     "Statement" : [{
#       "Effect" : "Allow",
#       "Principal" : {
#         #"AWS" : "arn:aws:iam::531831388604:user/q8jj0000-s"
#         "AWS" : data.snowflake_storage_integrations.current
#       },
#       "Action" : "sts:AssumeRole",
#       "Sid" : ""
#       "Condition" : {
#         "StringEquals" : {
#           #"sts:ExternalId" : "TT96852_SFCRole=2_xwSf5E4dGHJpEp4idwujQZnWoDo="
#           "sts:ExternalId" : "${module.dpa_poc_snowflake.storage_external_id}"
#         }
#       }
#     }]
#   })
#   #depends_on = [module.dpa_poc_snowflake]
# }


# resource "aws_iam_policy" "dpa-snowflake-s3-storage-access-policy" {
#   count       = length(var.dpa_bucket_name)
#   name        = "dpa_snowflake_s3_storage_access_policy${var.dpa_bucket_name[count.index]}"
#   description = "Allow read and write access to s3 bucket"
#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         "Effect" : "Allow",
#         "Action" : [
#           "s3:Getobject", "s3:ListBucket", "s3:PutObject*"
#         ],
#         Resource = ["${module.dpa_poc_bucket[count.index].s3_bucket_arn}", "${module.dpa_poc_bucket[count.index].s3_bucket_arn}/*"]
#       }
#     ]
#   })
# }

# resource "aws_iam_role_policy_attachment" "dpa-snowflake-storage-policy-attachment" {
#   count      = length(var.dpa_bucket_name)
#   role       = aws_iam_role.dpa-snowflake-s3-storage-access-role.name
#   policy_arn = aws_iam_policy.dpa-snowflake-s3-storage-access-policy[count.index].arn
# }


