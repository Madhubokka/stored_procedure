locals {
  admin_username = "practice_user"
  account_id     = data.aws_caller_identity.current.account_id
}

resource "aws_kms_key" "dpa-kms-for-s3" {
  description              = "${var.project_name} KMS key is used to encrypt bucket objects"
  customer_master_key_spec = var.key_spec
  is_enabled               = var.enabled
  enable_key_rotation      = var.rotation_enabled

  policy = data.aws_iam_policy_document.dpa-poc-kms-policy.json

  tags = {
    Name            = "dpa_poc_kms"
    Confidentiality = var.confidentality
    Compliance      = var.compliance
    "Cost Center"   = var.cost_center
    Environment     = var.env
    Owner           = var.owner
    Project         = var.project_name

  }
}

resource "aws_kms_alias" "dpa-kms-for-s3" {
  name          = "alias/poc_das_s3"
  target_key_id = aws_kms_key.dpa-kms-for-s3.id
}


data "aws_iam_policy_document" "dpa-poc-kms-policy" {
  statement {
    sid       = "Enable IAM User Permissions"
    effect    = "Allow"
    actions   = ["kms:*"]
    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${local.account_id}:root"]
    }
  }

  statement {
    sid       = "Allow access for Key Administrators"
    effect    = "Allow"
    actions   = ["kms:*"]
    resources = ["*"]

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${local.account_id}:user/${local.admin_username}",
        "arn:aws:iam::${local.account_id}:role/aws-service-role/support.amazonaws.com/AWSServiceRoleForSupport",
        "arn:aws:iam::${local.account_id}:role/aws-service-role/trustedadvisor.amazonaws.com/AWSServiceRoleForTrustedAdvisor"
      ]
    }
  }

  statement {
    sid    = "Allow use of the key"
    effect = "Allow"
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    resources = ["*"]

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${local.account_id}:user/${local.admin_username}",
        "arn:aws:iam::${local.account_id}:role/aws-service-role/support.amazonaws.com/AWSServiceRoleForSupport",
        "arn:aws:iam::${local.account_id}:role/aws-service-role/trustedadvisor.amazonaws.com/AWSServiceRoleForTrustedAdvisor"
      ]
    }
  }

  statement {
    sid    = "Allow attachment of persistent resources"
    effect = "Allow"
    actions = [
      "kms:CreateGrant",
      "kms:ListGrants",
      "kms:RevokeGrant"
    ]
    resources = ["*"]

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${local.account_id}:user/${local.admin_username}",
        "arn:aws:iam::${local.account_id}:role/aws-service-role/support.amazonaws.com/AWSServiceRoleForSupport",
        "arn:aws:iam::${local.account_id}:role/aws-service-role/trustedadvisor.amazonaws.com/AWSServiceRoleForTrustedAdvisor"
      ]
    }

    condition {
      test     = "Bool"
      variable = "kms:GrantIsForAWSResource"
      values   = ["true"]
    }
  }
}
