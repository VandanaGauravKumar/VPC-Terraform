##AWS common variables
variable "region" {
  default = "ap-southeast-2"
}

#variable "profile" {
#   description = "AWS credentials profile you want to use"
#}

# Variables for VPC
variable "vpc-cidr" {
  type        = string
  description = "cidr range for development vpc"
}

variable "env" {
  description = "Environment TAG"
}

variable "public_1a" {}
variable "private_1a" {}
variable "availability_zone_1a" {}
variable "public_1b" {}
variable "private_1b" {}
variable "availability_zone_1b" {}
variable "public_1c" {}
variable "private_1c" {}
variable "availability_zone_1c" {}

#Variables for S3
#variable "s3-bucket-id" {}

#variables for RDS

variable "allocated_storage" {}
variable "engine_version" {}
variable "instance_class" {}
variable "engine" {}
variable "username" {}
variable "password" {
  sensitive = true
}

# EKS
variable "nodesize" {}
variable "desired_size" {}
variable "max_size" {}
variable "min_size" {}
variable "eksrole" {}
variable "nodegrouprole" {}
#Change 1
# SSH Key Pair
variable "public_key" { 
}