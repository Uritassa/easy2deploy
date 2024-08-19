
resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name

  tags   = var.bucket_tags
}

resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "this" {
  depends_on = [aws_s3_bucket_ownership_controls.this]

  bucket = aws_s3_bucket.this.id
  acl    = "private"
}

resource "aws_kms_key" "this" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = var.kms_key_deletion_window_in_days

  tags                    = var.kms_key_tags
}

resource "aws_kms_alias" "this" {
  name          = "alias/${var.kms_key_alias_name}"
  target_key_id = aws_kms_key.this.key_id
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.this.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = "Enabled"
  }
}