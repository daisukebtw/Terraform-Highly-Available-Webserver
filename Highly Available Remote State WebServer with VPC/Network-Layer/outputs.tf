# Outputing VPC ID
output "vpc_id" {
  value = aws_vpc.main.id
}

# Outputing VPC CIDR BLOCKS
output "cidr_block" {
  value = aws_vpc.main.cidr_block
}

# Outputing all Subnet IDs
output "public_subnets_ids" {
  value = aws_subnet.public_subnets[*].id
}
