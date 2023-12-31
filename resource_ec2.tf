data "aws_ami" "latest_amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["RHEL-9.3.0_HVM-*-x86_64-5-Hourly2-GP2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "web" {
      ami           = data.aws_ami.latest_amazon_linux.id
      instance_type = var.instanceType
      key_name = aws_key_pair.my_key_pair.key_name
      vpc_security_group_ids = [aws_security_group.web_sg.id]
      tags = {
            Name = var.instanceTagName
      }
}

output "instance" {
  value = aws_instance.web.public_ip
}

