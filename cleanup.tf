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

resource "null_resource" "cleanup" {
  provisioner "local-exec" {
    command = <<-EOT
      aws ec2 terminate-instances --instance-ids ${join(" ", [
        for id in data.aws_instances.extras.ids : id
        if id != aws_instance.app_server[0].id
      ])}
    EOT
  }

  triggers = {
    instance_ids = join(",", data.aws_instances.extras.ids)
  }
}
