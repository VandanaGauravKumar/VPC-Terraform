# Create security group to control the traffic to RDS instance

resource "aws_security_group" "rds_sg" {
  name        = "rds-sg"
  description = "Allow inbound traffic for RDS"
  vpc_id      = var.vpc-id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    #cidr_blocks = ["10.0.0.0/16"]  # Allow traffic from within the VPC
    cidr_blocks = [var.vpc-cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Allow all outbound traffic
  }
}

# Create the RDS instance in Private Subnets
resource "aws_db_subnet_group" "main-db-subnet-gp" {
  name        = "main-db-subnet-group"
  subnet_ids  = [var.subnet_private_1a, var.subnet_private_1b, var.subnet_private_1c]
  description = "Private subnets for RDS instance"
}

resource "aws_db_instance" "tf-RDS" {
  identifier        = "my-rds-instance"
  instance_class    = var.instance_class 
  engine            = var.engine      
  engine_version    = var.engine_version          
  allocated_storage = var.allocated_storage
  db_subnet_group_name = aws_db_subnet_group.main-db-subnet-gp.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  multi_az          = false         # Set to true if you want Multi-AZ deployment
  publicly_accessible = false       # Ensures the RDS endpoint is private
  storage_encrypted = true
  username          = "admin"
  password          = "password123#"  
  skip_final_snapshot = true
  tags = {
    Name = "My RDS Instance"
  }
}



