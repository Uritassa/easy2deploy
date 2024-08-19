output "s3_bucket_id" {
  description = "ID of the created S3 bucket"
  value       = aws_s3_bucket.this.id
}

output "s3_bucket_arn" {
  description = "ARN of the created S3 bucket"
  value       = aws_s3_bucket.this.arn
}

output "kms_key_arn" {
  description = "ARN of the created KMS key"
  value       = aws_kms_key.this.arn
}

output "kms_key_alias_name" {
  description = "Name of the created KMS key alias"
  value       = aws_kms_alias.this.name
}