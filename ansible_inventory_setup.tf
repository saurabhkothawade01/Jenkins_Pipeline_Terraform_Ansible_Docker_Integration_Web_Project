resource "null_resource" "webConf" {

      triggers = {
            mykey = timestamp()
      }

      provisioner "local-exec" {
            command = "echo [web] > inventory"
      }

      provisioner "local-exec" {
        command = "echo ${aws_instance.web.public_ip} ansible_user=ec2-user ansible_ssh_private_key_file=${var.privateKeyLocation} >> inventory"
      }
}

