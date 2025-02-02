# This file manages cleanup of resources

# Remove the protect tag from EC2
resource "aws_ec2_tag" "protect" {
  resource_id = "i-02095903fa9586491"
  key         = "Protected"
  value       = "false"
}

# Output resources to be cleaned
output "cleanup_info" {
  value = {
    rds_instance     = aws_db_instance.mysql.id
    ec2_instance     = "i-02095903fa9586491"
    security_groups  = [aws_security_group.rds.id]
    vpc_id          = data.aws_vpc.default.id
  }
  description = "Resources that will be cleaned up"
}
