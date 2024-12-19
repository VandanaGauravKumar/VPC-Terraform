resource "aws_key_pair" "jump-host-key" {
  key_name   = "jump-host-key"
  public_key = var.public_key
}

resource "aws_key_pair" "Worker-Nodes-Key" {
    key_name   = "Worker-Nodes-Key"
  public_key = var.public_key
}