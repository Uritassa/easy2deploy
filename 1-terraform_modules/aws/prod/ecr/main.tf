resource "aws_ecr_repository" "this" {
  name                 = var.ecr_repo_name
  image_scanning_configuration {
    scan_on_push = true
  }
  image_tag_mutability = "IMMUTABLE"
  tags = var.tags
}