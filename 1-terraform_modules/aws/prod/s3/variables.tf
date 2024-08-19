variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}
variable "kms_key_alias_name" {
  description = "Name of the KMS key alias"
  type        = string
}
variable "kms_key_deletion_window_in_days" {
  description = "Number of days to wait before permanently deleting a KMS key"
  type        = number
}
variable "bucket_tags" {
  description = "Tags to apply to the S3 bucket"
  type        = map(string)
}

variable "kms_key_tags" {
  description = "Tags to apply to the KMS key"
  type        = map(string)
}