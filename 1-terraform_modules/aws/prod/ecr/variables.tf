variable "ecr_repo_name" {
    description = "Name of the ECR"
    type = string
}
variable "tags" {
    description = "Tags for the ECR"
    type = map(string)
}