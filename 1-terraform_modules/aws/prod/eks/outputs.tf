variable "eks_cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "eks_version" {
  description = "EKS cluster version"
  type        = string
  default     = "1.24"  # You can adjust this to the desired version
}