# step 0
# provider aws
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.24.1"
    }
  }
}
provider "aws" {
  # paris
  region = "eu-west-3"
}

# step 1 
# vpc and subnet reation
resource "aws_vpc" "demo_vpc" {
  cidr_block = "10.1.0.0/16"
  tags = {
    "Name" = "demo_vpc"
  }
}
resource "aws_subnet" "demo_subnet" {
  vpc_id     = aws_vpc.demo_vpc.id
  cidr_block = "10.1.0.0/24"
  tags = {
    Name         = "demo_subnet"
  }
}

# step 2
# internet gateway
resource "aws_internet_gateway" "demo_igw" {
    vpc_id = aws_vpc.demo_vpc.id
    tags = {
      "Name" = "demo_igw"
    }
}
resource "aws_route_table" "demo_route_table" {
    vpc_id = aws_vpc.demo_vpc.id
    route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.demo_igw.id
    }
    tags = {
      "Name" = "demo_route_table"
    }
}
resource "aws_main_route_table_association" "demo_mrtb" {
  vpc_id         = aws_vpc.demo_vpc.id
  route_table_id = aws_route_table.demo_route_table.id
}

# step 3
# ec2 instance
data "aws_ami" "amazon-linux-2" {
 most_recent = true
 owners = [ "amazon" ]
 filter {
   name   = "name"
   values = ["amzn2-ami-hvm*"]
 }
}
resource "aws_security_group" "demo_sg" {
  vpc_id = aws_vpc.demo_vpc.id
  ingress {
    cidr_blocks = [ "0.0.0.0/0" ]
    from_port = 0
    to_port = 0
    protocol = "-1"
  }
egress {
    cidr_blocks = [ "0.0.0.0/0" ]
    from_port = 0
    to_port = 0
    protocol = "-1"
  }
  tags = {
    "Name" = "demo_sg"
  }
}
resource "aws_key_pair" "demo_key" {
  key_name = "demo-key"
  public_key = "<your-ssh-public-key>"
}
resource "aws_instance" "demo_instance" {
    instance_type = "t2.micro"
    ami = data.aws_ami.amazon-linux-2.id
    subnet_id = aws_subnet.demo_subnet.id
    associate_public_ip_address = true
    vpc_security_group_ids = [ aws_security_group.demo_sg.id ]
    key_name = aws_key_pair.demo_key.key_name
    tags = {
      "Name" = "demo_instance"
    }
}

# step 4
# output ec2 public ip
output "demo_instance_ip" {
  value = aws_instance.demo_instance.public_ip
}