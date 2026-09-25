# UBUNTU AMI

data "aws_ami" "ubuntu" {
  most_recent = true

  owners = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


# EC2 APPLICATION SERVER

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  subnet_id = aws_subnet.public_1.id

  vpc_security_group_ids = [
    aws_security_group.app_sg.id
  ]

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  associate_public_ip_address = true


  tags = {
    Name        = "${var.project_name}-web-server"
    Environment = var.environment
    Project     = "andrews-aws-legacy-migration"
  }
}