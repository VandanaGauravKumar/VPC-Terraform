# Output private endpoint

output "rds_endpoint" {
  value = aws_db_instance.tf-RDS.endpoint
}
