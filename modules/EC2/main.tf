
/*resource "aws_security_group" "demo-Nat_Instance-sg" {
  name        = "nat-instance-sg"
 
  vpc_id      =  var.vpc-id

  ingress {

    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
      }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
     }

  tags = {
    Name = "Nat-Instance-SG"
  }
}
*/
resource "aws_security_group" "demo-jump_host-sg" {
  name        = "jump-host-sg"
 
  vpc_id      =  var.vpc-id

  ingress {

    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
      }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
     }

  tags = {
    Name = "Jump-Host-SG"
  }
}
/*resource "aws_instance" "NAT_Instance" {
  ami                    = "ami-0012b42b681efc859"
  #ami = "ami-0146fc9ad419e2cfd"
  key_name               = "my-key-pair"
  #instance_type          = "t3.small"
  instance_type = "t2.micro"
  #subnet_id     = var.subnet_id
  subnet_id     = var.subnet_public_1a
  associate_public_ip_address = true
  source_dest_check = false
  vpc_security_group_ids = [aws_security_group.demo-Nat_Instance-sg.id]
  # Enable IP forwarding on the instance for NAT functionality
  user_data = <<-EOF
    #!/bin/bash
    # Enable IP forwarding
    echo 1 > /proc/sys/net/ipv4/ip_forward

    # Set up NAT for traffic going out to the internet
    iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
    service iptables save
  EOF

  tags = {
    Name = "EC2 Instance"
  }
} */

resource "aws_instance" "jump_host" {
  #ami                    = "ami-0012b42b681efc859"
  ami = "ami-0146fc9ad419e2cfd"
  #key_name               = "my-key-pair"
  key_name = var.public_key_name
  #instance_type          = "t3.small"
  instance_type = "t2.micro"
  #subnet_id     = var.subnet_id
  subnet_id     = var.subnet_public_1a
  associate_public_ip_address = true
  source_dest_check = false
  vpc_security_group_ids = [aws_security_group.demo-jump_host-sg.id]
  
  tags = {
    Name = "Jump Host"
  }
}



