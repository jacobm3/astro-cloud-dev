provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Terraform = true
      Owner     = "you@mail.com"
      TTL       = 7680
    }
  }
}

data "aws_ami" "latest-ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "astro-dev" {
  ami = data.aws_ami.latest-ubuntu.id

  # t3a.large; 2 vcpu, 8GB ram, ebs = $1.80/day
  # m5d.large; 2 vcpu, 8GB ram, nvme = $2.70/day
  # m5d.xlarge; 4 vcpu, 16GB ram, nvme = $5.42/day
  # c6a.xlarge: 4 vcpu, 8GB ram, ebs = $3.67/day

  instance_type   = var.instance_type
  key_name        = var.key_name
  user_data       = templatefile("userdata.sh", {hostname = var.hostname})
  security_groups = [aws_security_group.astro-dev.name]
  lifecycle {
    ignore_changes = [user_data]
  }
  tags = {
    Name = "astro-dev"
  }
}

resource "aws_security_group" "astro-dev" {
  name        = "astro-dev"
  description = "Allow Astro inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ingress_addr_list
  }

    ingress {
      description = "Astro_HTTP_redirects"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = var.ingress_addr_list
    }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.ingress_addr_list
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "airflow"
  }
}