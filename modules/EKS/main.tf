resource "aws_iam_role" "eks-iam-role" {
 name = var.eksrole

 path = "/"

 assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
  {
   "Effect": "Allow",
   "Principal": {
    "Service": "eks.amazonaws.com"
   },
   "Action": "sts:AssumeRole"
  }
 ]
}
EOF

}
#Assosiate IAM Policy to IAM Role
resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
 policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
 role    = aws_iam_role.eks-iam-role.name
}
resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly-EKS" {
 policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
 role    = aws_iam_role.eks-iam-role.name
}

resource "aws_eks_cluster" "eks" {
 name = var.env
 role_arn = aws_iam_role.eks-iam-role.arn

 vpc_config {
 subnet_ids = [var.subnet_private_1a, var.subnet_private_1b, var.subnet_private_1c]
  #subnet_ids = [var.subnet_public_1a, var.subnet_public_1b, var.subnet_public_1c]
  endpoint_private_access = true
  endpoint_public_access = false
  #public_access_cidrs = ["0.0.0.0/0"]
 }

 depends_on = [
  aws_iam_role.eks-iam-role,
  aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  aws_iam_role_policy_attachment.AmazonEKSClusterPolicy
 ]
}

resource "aws_security_group" "worker_node_sg" {
  name        = "eks-test"
  description = "Allow ssh inbound traffic"
  vpc_id      =  var.vpc-id

  ingress {
    description      = "ssh access"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["10.0.0.0/24"]
    #cidr_blocks =  [var.instance_id + "/32"]
    #cidr_blocks = flatten([module.EC2.aws_instance.Bastion_instance.public_ip + "/32"])
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  } 
}
## WorkerNode
resource "aws_iam_role" "workernodes" {
  name = var.nodegrouprole
 
  assume_role_policy = jsonencode({
   Statement = [{
    Action = "sts:AssumeRole"
    Effect = "Allow"
    Principal = {
     Service = "ec2.amazonaws.com"
    }
   }]
   Version = "2012-10-17"
  })
 }
 
 resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role    = aws_iam_role.workernodes.name
 }
 
 resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role    = aws_iam_role.workernodes.name
 }

 resource "aws_iam_role_policy_attachment" "EC2InstanceProfileForImageBuilderECRContainerBuilds" {
  policy_arn = "arn:aws:iam::aws:policy/EC2InstanceProfileForImageBuilderECRContainerBuilds"
  role    = aws_iam_role.workernodes.name
 }
 
 resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role    = aws_iam_role.workernodes.name
 }
# Creates the worker node in public subnet
 resource "aws_eks_node_group" "worker-node-group" {
  cluster_name  = aws_eks_cluster.eks.name
  node_group_name = "${var.env}-nodegroup"
  node_role_arn  = aws_iam_role.workernodes.arn
  subnet_ids   = [var.subnet_private_1a, var.subnet_private_1b, var.subnet_private_1c]
  #subnet_ids   = [var.subnet_public_1a, var.subnet_public_1b, var.subnet_public_1c]
  instance_types = [var.nodesize]
  ami_type = "AL2_x86_64"
  capacity_type = "ON_DEMAND"
  disk_size = 20
   
  
  remote_access {
    ec2_ssh_key = var.worker_key_name
    #ec2_ssh_key = "my-key-pair"
    #if we provided the ec2_ssh_key,then we need to provide the security group id ow it will by 
    #default create a remote access security group that will by default enable ssh access to the worker nodes(0.0.0.0/0)
    #source_security_group_ids = [aws_security_group.worker_node_sg.id]
      }
 
  scaling_config {
   desired_size = var.desired_size
   max_size   = var.max_size
   min_size   = var.min_size
  }
 
  depends_on = [
   aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
   aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
   aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
   aws_iam_role_policy_attachment.EC2InstanceProfileForImageBuilderECRContainerBuilds
  ]
  tags = {
    #Name = "public-Node-Group"
    Name = "private-Node-Group"
  }
 }

 # Create the worker nodes in Private subnet

/*resource "aws_eks_node_group" "worker-node-private-group" {
  cluster_name  = aws_eks_cluster.eks.name
  node_group_name = "${var.env}-nodegroup"
  node_role_arn  = aws_iam_role.workernodes.arn
  subnet_ids   = [var.subnet_private_1a, var.subnet_private_1b, var.subnet_private_1c]
  #subnet_ids   = [var.subnet_public_1a, var.subnet_public_1b, var.subnet_public_1c]
  instance_types = [var.nodesize]
  ami_type = "AL2_x86_64"
  capacity_type = "ON_DEMAND"
  disk_size = 20
  remote_access {
    ec2_ssh_key = "my-key-pair"
  }
 
  scaling_config {
   desired_size = var.desired_size
   max_size   = var.max_size
   min_size   = var.min_size
  }
 
  depends_on = [
   aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
   aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
   aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
   aws_iam_role_policy_attachment.EC2InstanceProfileForImageBuilderECRContainerBuilds
  ]
  tags = {
    Name = "private-Node-Group"
  }
 } */
