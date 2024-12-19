output "public_key_name" {
  description = "SSH Key Pair "
  value = aws_key_pair.jump-host-key.key_name
}
output "worker_key_name" {
  description = "SSH Key Pair "
  value = aws_key_pair.Worker-Nodes-Key.key_name
}