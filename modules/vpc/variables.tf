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
