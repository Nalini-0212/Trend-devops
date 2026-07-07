data aws_ami "ubuntu" {
  most_recent = true
  owners      = ["ubuntu"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  instance_tenancy     = "default"
  tags = {
    Name = "my-vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "ap-south-1a"
  tags = {
    Name = "public-subnet"
  }
}
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "my-igw"
  }
}
resource "aws_route_table" "Public_route_table" {
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }
  tags = {
    Name = "Public-route-table"
  }
}
resource "aws_route_table_association" "Public_route_table_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.Public_route_table.id
}


resource "aws_security_group" "Public_security_group" {
  name        = "Public-security-group"
  description = "Allow SSH ,Jenkins port and HTTP traffic"
  vpc_id      = aws_vpc.my_vpc.id

  dynamic ingress {
    for_each = var.ports
    content {
    from_port   = ingress.value
    to_port     = ingress.value
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }
  } 
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_role" "jenkins_ec2_role" {
  name = "jenkins_ec2_role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "tag-value"
  }
}

resource "aws_iam_instance_profile" "jenkins_ec2_profile" {
  name = "jenkins_ec2_profile"
  role = aws_iam_role.jenkins_ec2_role.name
}

resource "aws_iam_role_policy_attachment" "admin" {
  role       = aws_iam_role.jenkins_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}



resource "aws_instance" "jenkins_instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.Public_security_group.id]
  key_name      = var.key_name
  iam_instance_profile = aws_iam_instance_profile.jenkins_ec2_profile.name
  associate_public_ip_address = true
  root_block_device {
    volume_size = var.volume_size
    volume_type = "gp3"
  }
  user_data = <<-EOF
              #!/bin/bash
              set -e
              sudo apt update -y
              sudo apt install fontconfig openjdk-21-jre -y
              java -version
              sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
              https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key
              echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" \
              https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
              /etc/apt/sources.list.d/jenkins.list > /dev/null
              sudo apt update
              sudo apt install jenkins -y
              sudo systemctl enable jenkins
              sudo systemctl start jenkins
              sudo systemctl status jenkins
              EOF

  tags = {
    Name = "jenkins-instance"
  }
}
