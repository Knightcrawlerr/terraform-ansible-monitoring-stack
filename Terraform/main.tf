terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0.0"
    }
  }
}

provider "aws" {
    region = var.region
  
}

locals {
  name_prefix       = "ec2-monitoring-demo"
  instances = {
    "monitoring" = { name = "${local.name_prefix}-monitoring" }
    "appdemo-1"  = { name = "${local.name_prefix}-appdemo-1" }
    "appdemo-2"  = { name = "${local.name_prefix}-appdemo-2" }
    # Add more entries here for future app demo servers
  }
}

resource "aws_vpc" "ec2_monitoring_vpc" {
  cidr_block = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${local.name_prefix}-vpc"
    environment = var.environment
  }
  
}

resource "aws_subnet" "ec2_monitoring_subnet" {
  vpc_id            = aws_vpc.ec2_monitoring_vpc.id
  cidr_block        = var.subnet_cidr_block
  map_public_ip_on_launch = true
  availability_zone = var.availability_zone

  tags = {
    Name = "${local.name_prefix}-subnet"
    environment = var.environment
  }
}

resource "aws_internet_gateway" "ec2_monitoring_gateway" {
  vpc_id = aws_vpc.ec2_monitoring_vpc.id

  tags = {
    Name = "${local.name_prefix}-gateway"
    environment = var.environment
  }
  
}

resource "aws_route_table" "ec2_monitoring_route_table" {
  vpc_id = aws_vpc.ec2_monitoring_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ec2_monitoring_gateway.id
  }
  tags = {
    Name = "${local.name_prefix}-route-table"
    environment = var.environment
  }
}


resource "aws_route_table_association" "ec2_monitoring_route_table_association" {
  subnet_id      = aws_subnet.ec2_monitoring_subnet.id
  route_table_id = aws_route_table.ec2_monitoring_route_table.id  
  
}

resource "aws_security_group" "sg_monitoring" {
  vpc_id = aws_vpc.ec2_monitoring_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.name_prefix}-sg-monitoring"
    environment = var.environment
  }
}

resource "aws_security_group" "sg_appdemo" {
  vpc_id = aws_vpc.ec2_monitoring_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  
}

  ingress {
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9104
    to_port     = 9104
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.name_prefix}-sg-appdemo"
    environment = var.environment
  }

}

# resource "aws_instance" "servers" {
#   count         = 2
#   ami           = var.ami_id
#   instance_type = var.instance_type
#   key_name      = var.key_name
#   associate_public_ip_address = true
#   vpc_security_group_ids = [aws_security_group.ec2_monitoring_security_group.id]
#   subnet_id     = aws_subnet.ec2_monitoring_subnet.id
#   tags = {
#     Name        = "${local.name_prefix}-${count.index == 0 ? "monitoring" : "appdemo"}"
#     environment = var.environment
#   }
# }

resource "aws_instance" "servers" {
  for_each               = local.instances
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  associate_public_ip_address = true
  subnet_id              = aws_subnet.ec2_monitoring_subnet.id
  vpc_security_group_ids = each.key == "monitoring" ? [aws_security_group.sg_monitoring.id] : [aws_security_group.sg_appdemo.id]

  tags = {
    Name        = each.value.name
    environment = var.environment
  }
}