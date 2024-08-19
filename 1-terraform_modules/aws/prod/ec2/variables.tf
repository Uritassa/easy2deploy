variable "policy_name" {
    type = string
  
}

variable "policy_document" {
    type = string
  
}


variable "role_name" {
    type = string
  
}
variable "role_tags" {
    type = map(string)
  
}

variable "instance_profile_name" {
    type = string
}
variable "security_group_name" {
    type = string
  
}
variable "vpc_id" {
    type = string
  
}
variable "security_group_tag" {
    type = map(string)
  
}
variable "ingress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    description = string
  }))
  default = []
}

variable "egress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    description = string
  }))
  default = []
}

variable "launch_template_name" {
    type = string
  
}
variable "instance_type" {
    type = string
  
}
variable "ami" {
    type = string
  
}
variable "user_data" {
    description = "User data script to be executed on instance launch"
    type = string
    default = ""
  
}
variable "key_name" {
    type = string  
}

variable "launch_template_tags" {
    type = map(string)
  
}
variable "public_subnet_ids" {
    description = "List of IDs of the public subnets where the instance host will be launched"
    type = list(string)
  
}
variable "desired_capacity" {
  type        = number
  default     = 1
  description = "The desired capacity for the Auto Scaling group"
}

variable "max_size" {
  type        = number
  default     = 1
  description = "The maximum size for the Auto Scaling group"
}

variable "min_size" {
  type        = number
  default     = 1
  description = "The minimum size for the Auto Scaling group"
}
variable "create_eip" {
  type        = bool
  default     = false
  description = "Whether to create an Elastic IP and associate it with the instances"
}
variable "eip_tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags for the Elastic IP"
}
