# VPC Configuration
variable "vpc_name" {
    description = "VPC name"
    type        = string
}

variable "vpc_cidr" {
    description = "CIDR block for the VPC"
    type        = string
    default     = "10.0.0.0/16"
}

variable "enable_dns_support" {
    description = "Enable DNS support in the VPC"
    type        = bool
    default     = true
}

variable "enable_dns_hostnames" {
    description = "Enable DNS hostnames in the VPC"
    type        = bool
    default     = true
}

# Private Subnet Configuration
variable "private_cidrs" {
    description = "List of CIDR blocks for private subnets"
    type        = list(string)
    default     = [
        "10.0.0.0/24",
        "10.0.1.0/24",
        "10.0.2.0/24"
    ]
}

variable "az_private_1" {
    description = "Availability zone for the first private subnet"
    type        = string
}

variable "az_private_2" {
    description = "Availability zone for the second private subnet"
    type        = string
}

variable "az_private_3" {
    description = "Availability zone for the third private subnet"
    type        = string
}

variable "private_zone_names" {
    description = "List of names for private subnets"
    type        = list(string)
    default     = [
        "private-zone-1",
        "private-zone-2",
        "private-zone-3"
    ]
}

variable "create_private_zone2" {
    description = "Whether to create a second private zone"
    type        = bool
    default     = false
}

variable "create_private_zone3" {
    description = "Whether to create a third private zone"
    type        = bool
    default     = false
}

# Public Subnet Configuration
variable "public_cidrs" {
    description = "List of CIDR blocks for public subnets"
    type        = list(string)
    default     = [
        "10.0.3.0/24",
        "10.0.4.0/24",
        "10.0.5.0/24"
    ]
}

variable "az_public_1" {
    description = "Availability zone for the first public subnet"
    type        = string
}

variable "az_public_2" {
    description = "Availability zone for the second public subnet"
    type        = string
}

variable "az_public_3" {
    description = "Availability zone for the third public subnet"
    type        = string
}

variable "public_zone_names" {
    description = "List of names for public subnets"
    type        = list(string)
    default     = [
        "public-zone-1",
        "public-zone-2",
        "public-zone-3"
    ]
}

variable "create_public_zone2" {
    description = "Whether to create a second public zone"
    type        = bool
    default     = false
}

variable "create_public_zone3" {
    description = "Whether to create a third public zone"
    type        = bool
    default     = false
}

# igw

variable "internet_gateway_name" {
    description = "Name of the Internet Gateway"
    type        = string
}
  
# nat

variable "nat_gateway_name" {
    description = "Name of the NAT Gateway"
    type        = string
}