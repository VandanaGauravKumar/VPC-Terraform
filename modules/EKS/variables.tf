variable "env" {
    description = "Environment TAG"
}

variable "subnet_public_1a" {}
variable "subnet_private_1a" {}
variable "subnet_public_1b" {}
variable "subnet_private_1b" {}
variable "subnet_public_1c" {}
variable "subnet_private_1c" {}
variable "vpc-id" {}
#variable "SSH-Sg-id" {}
variable "instance_id" {}


variable "nodesize" {}
variable "desired_size" {}
variable "max_size" {}
variable "min_size" {}
variable "eksrole" {}
variable "nodegrouprole" {}
variable "worker_key_name" {}