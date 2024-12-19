
output "vpc-id" {
  value = aws_vpc.vpc.id
}

output "vpc-cidr" {
  value = aws_vpc.vpc.cidr_block
}

output "subnet_public_1a" {
  value = aws_subnet.subnet_public_1a.id
}

output "subnet_private_1a" {
  value = aws_subnet.subnet_private_1a.id
}

output "subnet_public_1b" {
  value = aws_subnet.subnet_public_1b.id
}

output "subnet_private_1b" {
  value = aws_subnet.subnet_private_1b.id
}

output "subnet_public_1c" {
  value = aws_subnet.subnet_public_1c.id
}

output "subnet_private_1c" {
  value = aws_subnet.subnet_private_1c.id
}