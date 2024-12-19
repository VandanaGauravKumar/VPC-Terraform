# Create a VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc-cidr
  enable_dns_support = "true" #gives you an internal domain name
  enable_dns_hostnames = "true" #gives you an internal host name
  #enable_classiclink = "false"
  instance_tenancy = "default"
    
  tags = {
        Name = "${var.env}"
        Environment = var.env
    }
}



# Create Subnet in 1a/1b/1c ( private / public )

resource "aws_subnet" "subnet_public_1a" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.public_1a
  availability_zone = var.availability_zone_1a
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.env}.subnet.public.1a"
    Environment = var.env
  }
}

resource "aws_subnet" "subnet_private_1a" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.private_1a
  availability_zone = var.availability_zone_1a
  
  tags = {
    Name = "${var.env}.subnet.private.1a"
    Environment = var.env
  }
}

resource "aws_subnet" "subnet_public_1b" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.public_1b
  availability_zone = var.availability_zone_1b
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.env}.subnet.public.1b"
    Environment = var.env
  }
}

resource "aws_subnet" "subnet_private_1b" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.private_1b
  availability_zone = var.availability_zone_1b
 
  tags = {
    Name = "${var.env}.subnet.private.1b"
    Environment = var.env
  }
}

resource "aws_subnet" "subnet_public_1c" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.public_1c
  availability_zone = var.availability_zone_1c
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.env}.subnet.public.1c"
    Environment = var.env
  }
}

resource "aws_subnet" "subnet_private_1c" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.private_1c
  availability_zone = var.availability_zone_1c
  
  tags = {
    Name = "${var.env}.subnet.private.1c"
    Environment = var.env
  }
}

## Create IGW

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.env}.igw"
    Environment = var.env
  }
}

# Elastic IP for NGW

resource "aws_eip" "ngw-ip" {
  domain = "vpc"
  
  tags = {
    Name = "${var.env}.ngw.ip"
  }
}

# NAT Gateway

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.ngw-ip.id
  subnet_id     = aws_subnet.subnet_public_1a.id

  tags = {
    Name = "${var.env}.ngw"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
} 

# Route Tables

/*resource "aws_route_table" "rt-public-1a" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.env}.rt.public.1a"
  }
}*/

resource "aws_default_route_table" "main-rt-public-1a" {
  default_route_table_id = aws_vpc.vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.env}.rt.public.1a"
  }
}

resource "aws_route_table" "rt-public-1b" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.env}.rt.public.1b"
  }
}

resource "aws_route_table" "rt-public-1c" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.env}.rt.public.1c"
  }
}

resource "aws_route_table" "rt-private-1a" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    #gateway_id = "local"
    nat_gateway_id = aws_nat_gateway.ngw.id
    #instance_id = aws_instance.Bastion_instance.id
  }

  tags = {
    Name = "${var.env}.rt.private.1a"
  }
}

resource "aws_route_table" "rt-private-1b" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    #gateway_id = "local"
    nat_gateway_id = aws_nat_gateway.ngw.id
  }

  tags = {
    Name = "${var.env}.rt.private.1b"
  }
}

resource "aws_route_table" "rt-private-1c" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    #gateway_id = "local"
    nat_gateway_id = aws_nat_gateway.ngw.id
    #instance_id = aws_instance.Bastion_instance.id
  }

  tags = {
    Name = "${var.env}.rt.private.1c"
  }
}

# Route Table association

resource "aws_route_table_association" "public-1a" {
  subnet_id      = aws_subnet.subnet_public_1a.id
  route_table_id = aws_default_route_table.main-rt-public-1a.id
}

resource "aws_route_table_association" "private-1a" {
  subnet_id      = aws_subnet.subnet_private_1a.id
  route_table_id = aws_route_table.rt-private-1a.id
}

resource "aws_route_table_association" "public-1b" {
  subnet_id      = aws_subnet.subnet_public_1b.id
  route_table_id = aws_route_table.rt-public-1b.id
}

resource "aws_route_table_association" "private-1b" {
  subnet_id      = aws_subnet.subnet_private_1b.id
  route_table_id = aws_route_table.rt-private-1b.id
}

resource "aws_route_table_association" "public-1c" {
  subnet_id      = aws_subnet.subnet_public_1c.id
  route_table_id = aws_route_table.rt-public-1c.id
}

resource "aws_route_table_association" "private-1c" {
  subnet_id      = aws_subnet.subnet_private_1c.id
  route_table_id = aws_route_table.rt-private-1c.id
}
