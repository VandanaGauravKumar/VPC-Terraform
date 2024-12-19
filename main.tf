# Configure the AWS Provider
#provider "aws" {
#profile    = "${var.profile}"
#region = var.region
# }
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.80.0"
    }
  }
}

/*terraform {
  backend "s3" {
    bucket = "my-tf-bucket-statefile"
    key = "global/mystatefile/terraform.tfstate"
    region= "ap-southeast-2" 
  }
}*/

module "key-pair" {
  source = "./modules/key-pair"
  public_key = var.public_key
}

module "vpc" {
  source               = "./modules/vpc"
  vpc-cidr             = var.vpc-cidr
  env                  = var.env
  public_1a            = var.public_1a
  private_1a           = var.private_1a
  availability_zone_1a = var.availability_zone_1a
  public_1b            = var.public_1b
  private_1b           = var.private_1b
  availability_zone_1b = var.availability_zone_1b
  public_1c            = var.public_1c
  private_1c           = var.private_1c
  availability_zone_1c = var.availability_zone_1c
}
module "ec2" {
  source = "./modules/EC2"
  subnet_public_1a  = module.vpc.subnet_public_1a
  vpc-id            = module.vpc.vpc-id
  public_key_name = module.key-pair.public_key_name
}
module "S3-Bucket" {
  source = "./modules/S3-Bucket"
  env    = var.env
}

module "RDS" {
  source            = "./modules/RDS"
  allocated_storage = var.allocated_storage
  engine_version    = var.engine_version
  instance_class    = var.instance_class
  engine            = var.engine
  username          = var.username
  password          = var.password
  subnet_private_1a = module.vpc.subnet_private_1a
  subnet_private_1b = module.vpc.subnet_private_1b
  subnet_private_1c = module.vpc.subnet_private_1c
  vpc-id            = module.vpc.vpc-id
  vpc-cidr          = module.vpc.vpc-cidr
}

module "eks" {
  source            = "./modules/EKS"
  vpc-id            = module.vpc.vpc-id
  #SSH-Sg-id = module.ec2.SSH-Sg-id
  instance_id = module.ec2.instance_id
  subnet_public_1a  = module.vpc.subnet_public_1a
  subnet_private_1a = module.vpc.subnet_private_1a
  subnet_public_1b  = module.vpc.subnet_public_1b
  subnet_private_1b = module.vpc.subnet_private_1b
  subnet_public_1c  = module.vpc.subnet_public_1c
  subnet_private_1c = module.vpc.subnet_private_1c
  worker_key_name = module.key-pair.worker_key_name
  env               = var.env
  nodesize          = var.nodesize
  desired_size      = var.desired_size
  max_size          = var.max_size
  min_size          = var.min_size
  eksrole           = var.eksrole
  nodegrouprole     = var.nodegrouprole
} 