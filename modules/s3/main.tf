
# S3 bucket creation
resource "aws_s3_bucket" "data-analytics-s3-main-bucket" {
  bucket = var.bucket_name
  #acl = "private"

}

/*
resource "aws_s3_bucket_acl" "data-analytics-s3-main-bucket-acl" {
  bucket = aws_s3_bucket.data-analytics-s3-main-bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_ownership_controls" "s3_bucket_acl_ownership" {
  bucket = aws_s3_bucket.data-analytics-s3-main-bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}
*/

# S3 bucket versioning
resource "aws_s3_bucket_versioning" "data-analytics-s3-main-versioning" {
  bucket = aws_s3_bucket.data-analytics-s3-main-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}


# S3 bucket lifecycle configuration
resource "aws_s3_bucket_lifecycle_configuration" "storage_lifecycle" {
  rule {
    id     = "log"
    status = "Enabled"

    transition {
      days          = 30
      storage_class = "GLACIER"
    }

    expiration {
      days = 365
    }
  }

  bucket = aws_s3_bucket.data-analytics-s3-main-bucket.id
}

# enable server-side encryption for the bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "data-analytics-server-side-encryption" {
  bucket = aws_s3_bucket.data-analytics-s3-main-bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = var.kms_key_arn
      # kms_master_key_id = "arn:aws:kms:ap-southeast-2:519990849220:alias/aws/s3"
    }
    bucket_key_enabled = true
  }
}

resource "aws_s3_object" "create-s3-folder" {
  # Must have bucket versioning enabled first
  count  = length(var.s3_folders)
  bucket = aws_s3_bucket.data-analytics-s3-main-bucket.id
  acl    = "private"
  key    = "${var.s3_folders[count.index]}/"
  source = ""

  lifecycle {
    prevent_destroy = false
  }
}



/*
resource "aws_s3_bucket_policy" "storage_bucket_policy" {
  bucket = aws_s3_bucket.data-analytics-s3-main-bucket.id
  policy = data.aws_iam_policy_document.storage_bucket_policy.json

}


data "aws_iam_policy_document" "storage_bucket_policy" {
  source_policy_documents = [var.custom_bucket_policy]
}
*/


