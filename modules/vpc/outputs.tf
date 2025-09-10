output "aws_vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.new_vpc.id
}

output "aws_subnet_ids" {
  description = "The IDs of the subnets"
  value       = aws_subnet.subnets[*].id
}
