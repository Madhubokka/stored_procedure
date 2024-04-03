data "aws_caller_identity" "current" {}


data "aws_iam_policy_document" "data-analytics-s3-write-access-policy-doc" {
  statement {
    effect    = "Allow"
    actions   = ["s3:GetObject", "s3:ListObject", "s3:PutObject"]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "data-analytics-s3-read-access-policy-doc" {
  statement {
    effect    = "Allow"
    actions   = ["s3:GetObject", "s3:ListObject"]
    resources = ["*"]
  }
}


data "aws_iam_policy_document" "storage_iam_s3_policy" {
  statement {
    effect = "Deny"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions   = ["s3:DeleteObject*"]
    resources = ["*"]
  }
  statement {
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.account_id}:role/aws_iam_role.data-analytics-s3-s3-write-access-role.name", "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws_iam_role.data-analytics-s3-s3-write-access-role.name"]
    }
    actions   = ["s3:GetObject", "s3:ListObject*", "s3:PutObject*"]
    resources = ["*"]
    condition {
      test     = "StringEquals"
      variable = var.user_access
      values   = ["write"]
    }
  }

  statement {
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.account_id}:role/aws_iam_role.data-analytics-s3-s3-read-access-role.name", "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws_iam_role.data-analytics-s3-s3-read-access-role.name"]
    }
    actions   = ["s3:GetObject", "s3:ListObject*"]
    resources = ["*"]
    condition {
      test     = "StringEquals"
      variable = var.user_access
      values   = ["read"]
    }
  }
  #depends_on = [module.dpa_poc_bucket]
}


# data "aws_iam_policy_document" "dpa_snowflake_role_policy" {
#   # depends_on = [
#   #   module.dpa_poc_bucket,
#   #   module.dpa_poc_snowflake
#   # ]
#   statement {
#     effect  = "Allow"
#     actions = ["sts:AssumeRole"]
#     sid     = ""
#     principals {
#       type        = "AWS"
#       identifiers = [snowflake_storage_integration.dpa_integration.storage_aws_iam_user_arn]
#       #"AWS" : "arn:aws:iam::531831388604:user/q8jj0000-s"
#       #AWS = module.dpa_poc_snowflake.storage_user_arn
#     }
#     condition {
#       test     = "StringEquals"
#       values   = [snowflake_storage_integration.dpa_integration.storage_aws_external_id]
#       variable = "sts:ExternalId"
#       #"sts:ExternalId" = module.dpa_poc_snowflake.storage_external_id
#       # "TT96852_SFCRole=2_xwSf5E4dGHJpEp4idwujQZnWoDo="
#     }
#   }
# }





#  condition {
#     test     = "StringEquals"
#     values   = ["bucket-owner-full-control"]
#     variable = "s3:x-amz-acl"
#   }


# data "aws_iam_policy_document" "ecs_service" {
#   statement {
#     effect = "Allow"
#     actions = ["sts:AssumeRole"]
#     principals = {
#       type = "Service"
#       identifiers = ["ecs.amazonaws.com"]
#     }
#   }
# }


# data "aws_iam_policy_document" "example" {
#   statement {
#     sid = "1"

#     actions = [
#       "s3:ListAllMyBuckets",
#       "s3:GetBucketLocation",
#     ]

#     resources = [
#       "arn:aws:s3:::*",
#     ]
#   }

#   statement {
#     actions = [
#       "s3:ListBucket",
#     ]

#     resources = [
#       "arn:aws:s3:::${var.s3_bucket_name}",
#     ]

#     condition {
#       test     = "StringLike"
#       variable = "s3:prefix"

#       values = [
#         "",
#         "home/",
#         "home/&{aws:username}/",
#       ]
#     }
#   }

#   statement {
#     actions = [
#       "s3:*",
#     ]

#     resources = [
#       "arn:aws:s3:::${var.s3_bucket_name}/home/&{aws:username}",
#       "arn:aws:s3:::${var.s3_bucket_name}/home/&{aws:username}/*",
#     ]
#   }
# }

# resource "aws_iam_policy" "example" {
#   name   = "example_policy"
#   path   = "/"
#   policy = data.aws_iam_policy_document.example.json
# }
