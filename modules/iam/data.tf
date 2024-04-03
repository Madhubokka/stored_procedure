data "aws_caller_identity" "current" {}

data "aws_partition" "current" {}


data "aws_iam_policy_document" "dpa-snowflake-s3-storage-access-policy-document" {
  statement {
    effect = "Deny"
    # principals {
    #   type        = "AWS"
    #   identifiers = ["*"]
    # }
    actions   = ["s3:DeleteObject*"]
    resources = ["*"]
  }
  statement {
    effect = "Allow"
    # principals {
    #   type        = "AWS"
    #   identifiers = ["*"]
    # }
    actions   = ["s3:Getobject", "s3:ListBucket", "s3:PutObject*", "s3:PutObjectTagging"]
    resources = ["arn:aws:s3:::${var.s3_bucket_name}", "arn:aws:s3:::${var.s3_bucket_name}/*"]
    condition {
      test     = "ArnLike"
      variable = "aws:PrincipalArn"
      values   = ["arn:${local.partition}:iam::${local.account_id}:role${var.role_path}${local.role_name_condition}"]
    }
    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values   = ["*"]
    }
  }

  statement {
    effect = "Allow"
    # principals {
    #   type        = "AWS"
    #   identifiers = ["*"]
    # }
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    resources = ["arn:aws:s3:::${var.s3_bucket_name}", "arn:aws:s3:::${var.s3_bucket_name}/*"]
    condition {
      test     = "ArnLike"
      variable = "aws:PrincipalArn"
      values   = ["arn:${local.partition}:iam::${local.account_id}:role${var.role_path}${local.role_name_condition}"]
    }
    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values   = ["*"]
    }
  }

  #depends_on = [module.dpa_poc_bucket]
}


