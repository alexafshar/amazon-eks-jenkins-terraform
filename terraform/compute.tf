
data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = [
      "amzn2-ami-hvm-*-x86_64-gp2",
    ]
  }
  filter {
    name = "owner-alias"
    values = [
      "amazon",
    ]
  }
}

resource "aws_instance" "jenkins-instance" {
  ami             = data.aws_ami.amazon-linux-2.id
  instance_type   = "t2.medium"
  key_name        = var.keyname
  vpc_security_group_ids = [aws_security_group.sg_allow_ssh_jenkins.id]
  subnet_id          = aws_subnet.public-subnet-1.id
//  name            = "${var.name}"
  user_data = file("install_jenkins.sh")

  associate_public_ip_address = true
  tags = {
    Name = "cse-jenkins-1",
    Team = "cse"
  }

  // copy the files to newly created instance
  provisioner "file" {
    source      = "files/jenkins-proxy"
    destination = "/tmp/jenkins-proxy"
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("~/.ssh/cseawskey.pem")
      host        = self.public_dns
    }
  }

  provisioner "file" {
    source      = "files/Dockerfile"
    destination = "/tmp/Dockerfile"

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("~/.ssh/cseawskey.pem")
      host        = self.public_dns
    }
  }
//
  provisioner "file" {
    source      = "files/jenkins-plugins"
    destination = "/tmp/jenkins-plugins"
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("~/.ssh/cseawskey.pem")
      host        = self.public_dns
    }

  }
//
  provisioner "file" {
    source      = "files/default-user.groovy"
    destination = "/tmp/default-user.groovy"
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("~/.ssh/cseawskey.pem")
      host        = self.public_dns
    }

  }

}

resource "aws_security_group" "sg_allow_ssh_jenkins" {
  name        = "allow_ssh_jenkins"
  description = "Allow SSH and Jenkins inbound traffic"
  vpc_id      = aws_vpc.development-vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.development-vpc.cidr_block]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.development-vpc.cidr_block]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.development-vpc.cidr_block]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Team = "cse"
  }
}

output "jenkins_ip_address" {
  value = aws_instance.jenkins-instance.public_dns
}
