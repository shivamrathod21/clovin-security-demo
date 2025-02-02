# This file will help clean up extra instances
data "aws_instances" "extras" {
  filter {
    name   = "tag:Name"
    values = ["seminar-crud-demo"]
  }

  filter {
    name   = "instance-state-name"
    values = ["running"]
  }
}

# Protect our working instance
resource "aws_ec2_tag" "protect" {
  resource_id = "i-02095903fa9586491"
  key         = "Protected"
  value       = "true"
}

# This is just for documentation - our working instance
output "working_instance" {
  value = {
    instance_id = "i-02095903fa9586491"
    public_ip  = "34.217.13.222"
    port       = "5000"
  }
  description = "Details of our working instance"
}
