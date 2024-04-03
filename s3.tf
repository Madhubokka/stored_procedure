/*
terraform {
  backend "s3" {}
}


locals {
  admin_username = "waleed"
  aws_account_id     = data.aws_caller_identity.current.account_id
}
*/


module "dpa_poc_bucket" {
  source               = "./modules/s3"
  count                = var.env == "sandbox" ? length(var.dpa_bucket_name) : 0
  env                  = var.env
  bucket_name          = "${var.project_name}-${var.env}-${var.domain}-${var.dpa_bucket_name[count.index]}"
  project_name         = var.project_name
  confidentality       = var.confidentality
  compliance           = var.compliance
  cost_center          = var.cost_center
  owner                = var.owner
  account_name         = var.account_name
  domain               = var.domain
  kms_key_arn          = aws_kms_key.dpa-kms-for-s3.arn
  account_id           = data.aws_caller_identity.current.account_id
  custom_bucket_policy = data.aws_iam_policy_document.storage_iam_s3_policy.json
}

/*
resource "aws_s3_bucket_policy" "bucket_policy" {

  bucket = aws_s3_bucket.client_host_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "MYBUCKETPOLICY"
    Statement = [
      {

        Effect    = "Allow"
        Principal = "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity E1DH5IWVP378YX"
        Action    = "s3:GetObject"
        Resource = [
          "arn:aws:s3:::dsdsdd-host-bucket/*"
        ]

      },
    ]
  })

}
*/




resource "aws_s3_bucket_policy" "data-analytics-cross-sharing-policy" {
  count  = length(var.dpa_bucket_name)
  bucket = module.dpa_poc_bucket[count.index].s3_bucket_id

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Id": "Policy1357935677554",
    "Statement": [
        {
            "Sid": "Stmt1357935647218",
            "Effect": "Allow",
            "Principal": {
                "AWS": "${aws_iam_role.data-analytics-s3-s3-read-access-role.arn}"
            },
            "Action": "s3:ListBucket",
            "Resource": ["${module.dpa_poc_bucket[count.index].s3_bucket_arn}","${module.dpa_poc_bucket[count.index].s3_bucket_arn}/*"]
        },
        {
            "Sid": "Stmt1357935676138",
            "Effect": "Allow",
            "Principal": {
                "AWS": "${aws_iam_role.data-analytics-s3-s3-write-access-role.arn}"
            },
            "Action": [
                "s3:GetObject",
                "s3:PutObject"
            ],
            "Resource": ["${module.dpa_poc_bucket[count.index].s3_bucket_arn}","${module.dpa_poc_bucket[count.index].s3_bucket_arn}/*"]
        }
        
    ]
}
POLICY
  #depends_on = module.dpa_poc_bucket[0].s3_bucket_name
}


/*
# S3 bucket cross account sharing policy
resource "aws_s3_bucket_policy" "data-analytics-cross-sharing-policy" {
  bucket = module.dpa_poc_bucket[0].s3_bucket_id

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "CROSSBUCKETPOLICY"
    Statement = [
      {
        Sid    = "AllowPublic"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${var.account_id}"
        },
        Action = ["s3:DeleteObjects*", "s3:PutObjects*", "s3:GetObjects", "s3:ListObjects"]
        Resource = [
          "arn:aws:s3:::module.dpa_poc_bucket[0].s3_bucket_arn",
          "arn:aws:s3:::module.dpa_poc_bucket[0].s3_bucket_arn/*"
        ]
      },
      {
        Sid    = "DenyAll"
        Effect = "Deny"
        Principal = {
          AWS = "*"
        },
        Action = ["s3:DeleteObjects", "s3:PutObjects"]
        Resource = [
          "arn:aws:s3:::module.dpa_poc_bucket[0].s3_bucket_arn",
          "arn:aws:s3:::module.dpa_poc_bucket[0].s3_bucket_arn/*"
        ]
      }
    ]
  })
}
*/

/*
# S3 bucket cross account sharing policy
resource "aws_s3_bucket_policy" "data-analytics-cross-sharing-policy" {
  bucket = module.dpa_poc_bucket[0].s3_bucket_id

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "MYBUCKETPOLICY"
    statement = [
      {
        Effect = "Deny"
        Principal = {
          AWS = "*"
        },
        Action = ["s3:DeleteObjects", "s3:PutObjects"]
        Resource = [
          "arn:aws:s3:::module.dpa_poc_bucket[0].s3_bucket_arn",
          "arn:aws:s3:::module.dpa_poc_bucket[0].s3_bucket_arn/*"
        ]
        creation = {
          test     = "BoolIfExists"
          varaible = ["arn:aws:iam:::${var.account_id}:"]
          values   = "false"
        }
      },
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${var.account_id}"
        },
        Action = ["s3:DeleteObjects*", "s3:PutObjects*", "s3:GetObjects", "s3:ListObjects"]
        Resource = [
          "arn:aws:s3:::module.dpa_poc_bucket[0].s3_bucket_arn",
          "arn:aws:s3:::module.dpa_poc_bucket[0].s3_bucket_arn/*"
        ]
      },

    ]
    }

  )
}
*/
