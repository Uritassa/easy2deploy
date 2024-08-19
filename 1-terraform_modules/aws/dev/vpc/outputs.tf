output "vpc_id" {
    description = "ID of the VPC"
    value       = aws_vpc.main.id
}

output "private_subnet_ids" {
  description = "The IDs of the private subnets"
  value       = [
    aws_subnet.private_zone1.id,
    aws_subnet.private_zone2.id,
    aws_subnet.private_zone3.id
  ]
}

output "public_subnet_ids" {
  description = "The IDs of the public subnets"
  value       = [
    aws_subnet.public_zone1.id,
    aws_subnet.public_zone2.id,
    aws_subnet.public_zone3.id
  ]
}