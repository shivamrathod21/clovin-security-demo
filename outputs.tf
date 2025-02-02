output "db_endpoint" {
  description = "The RDS endpoint"
  value       = aws_db_instance.clovin_db.endpoint
}
