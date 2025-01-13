## VPC variables
vpc-cidr = "10.0.0.0/16"
env      = "development"

## Subnet
public_1a  = "10.0.0.0/24"
private_1a = "10.0.1.0/24"
public_1b  = "10.0.2.0/24"
private_1b = "10.0.3.0/24"
public_1c  = "10.0.4.0/24"
private_1c = "10.0.5.0/24"

availability_zone_1a = "ap-southeast-2a"
availability_zone_1b = "ap-southeast-2b"
availability_zone_1c = "ap-southeast-2c"

## RDS variables

allocated_storage = 20
engine_version    = "8.0"
instance_class    = "db.t3.micro"
engine            = "mysql"
username          = "admin"
password          = "password123#"


# EKS 
nodesize      = "t2.medium"
eksrole       = "eks-iam-role"
nodegrouprole = "eks-node-group-role"
desired_size  = "2"
max_size      = "2"
min_size      = "1"

#SSH Key Pair
public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDKxV7z/0tMbCJ9T78CWC1dPVh9yHx/NuanxIjKoranjCfyQyMhmiQmS/2XUJpT1RMMH8TNiSVWg4szig2fprtSvTyn/NZXjoE0SB/YurutUWIA+JUfAkgwcTaRU3Ex1rn0WtUbdxmra57WcKIgMqswZAkQHivu0LZ2z/PE1UOUOLYvGCQzVQ6M5IOiVjzEznm/JQx/AVFyurCY2CmiOteTAzrZb3k5kStzJh81ffCIiAD81zUMZc4kBTdgUHsQ9c2SY8vB3ZDE7EbhNHz4WwmtcsCpUgHA+7lpSoRysmUpCo57Wvc/8KQiFtQZmgVD+ZgfPQxyDuIYr8hV6pCJdRdt vandana@LAPTOP-GT40USIO"