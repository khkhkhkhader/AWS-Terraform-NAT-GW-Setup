#---------------Task2------------------

# Creat VPC

resource "aws_vpc" "myvpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "Task2-VPC"
  }
}

# Creat Public Subnet 

resource "aws_subnet" "mypubsub" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = var.public_subnet_cidr
  map_public_ip_on_launch = true
  tags = {
    Name = "Task2 Public Subnet"
  }
}

# Creat Private Subnet 

resource "aws_subnet" "myprivatesub" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = var.priv_subnet_cidr
  tags = {
    Name = "Task2 Private Subnet"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "IGW"
  }
}


# Create Elastic IP for the NAT Gateway
resource "aws_eip" "nat" {
  domain  =  "vpc"
}

# Create NAT Gateway in the Public Subnet

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat.id  
  subnet_id     = aws_subnet.mypubsub.id

  tags = {
    Name = "NAT Gateway"
  }
  depends_on = [ aws_internet_gateway.IGW ]
}

 # Create Route Table for pub subnet
resource "aws_route_table" "pub_RT" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }

  tags = {
    Name = "PUB_RT"
  }
}

# Creat Route Table for priv subnet

resource "aws_route_table" "priv_RT"{
  vpc_id = aws_vpc.myvpc.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gateway.id
  }

    tags = {
      Name = "Priv_RT"
    }
   
}

# Creat RT PUB association
resource "aws_route_table_association" "pup_associatiob" {
  subnet_id      = aws_subnet.mypubsub.id
  route_table_id = aws_route_table.pub_RT.id

}

# Creat RT priv association
resource "aws_route_table_association" "priv_association" {
  subnet_id      = aws_subnet.myprivatesub.id
  route_table_id = aws_route_table.priv_RT.id

}


# Create pub security group 
resource "aws_security_group" "pub_sg"{
  name        = "pub_sg"
  description = "Allow HTTP, HTTPS, and SSH traffic"
  vpc_id      = aws_vpc.myvpc.id

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "pub_sg"
  }
}


  

# Create pub EC2
resource "aws_instance" "Pub_EC2" {
  ami           = var.ami
  instance_type = var.instance_type
 key_name      = var.Key_pair
  subnet_id              = aws_subnet.mypubsub.id
  vpc_security_group_ids = [aws_security_group.pub_sg.id]
  associate_public_ip_address = true

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install httpd -y
    systemctl start httpd
    systemctl enable httpd
    echo "<h1>Welcome to the new EC2 instance1</h1>" > /var/www/html/index.html
  EOF

  tags = {
    Name = "instance1"
  }
}

# Create priv EC2
resource "aws_instance" "Priv_Ec2" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.Key_pair
  subnet_id              = aws_subnet.myprivatesub.id
  vpc_security_group_ids = [aws_security_group.pub_sg.id]
  associate_public_ip_address = false

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install httpd -y
    systemctl start httpd
    systemctl enable httpd
    echo "<h1>Welcome to the new EC2 instance2</h1>" > /var/www/html/index.html
  EOF

  tags = {
    Name = "instance2"
  }
}

# Creat S3 bucket for backend

resource "aws_s3_bucket" "be"{
  bucket = "my-be-bucket-for-proj" 
  
  tags = {
    Name        = "be-bucket"
    Environment = "test"
  }
}

