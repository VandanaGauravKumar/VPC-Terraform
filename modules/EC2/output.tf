output "instance_id" {
 #value = aws_instance.Bastion_instance.id
 # value = aws_instance.public_ip
  value= aws_instance.jump_host.public_ip
}


