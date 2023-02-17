provider "aws" {
  region = var.region
}

resource "aws_instance" "hackathon_starter" {
  ami           = var.ami_id
  instance_type = var.instance_type

  # Replace with your own SSH key name
  key_name = "mykey"

  vpc_security_group_ids = [
    aws_security_group.myid_group.id,
  ]

  tags = {
    Name = "hackathon-starter"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo amazon-linux-extras install ansible2 -y",
    ]
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("~/.ssh/mykey.pem")
    host        = self.public_ip
  }
}

resource "aws_security_group" "example" {
  name_prefix = "mysg_group"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "null_resource" "ansible" {
  provisioner "local-exec" {
    command = "ansible-playbook -i '${aws_instance.hackathon_starter.public_ip},' mongodb.yml"
    environment = {
      ANSIBLE_HOST_KEY_CHECKING = "False"
    }
  }

  depends_on = [
    aws_instance.hackathon_starter,
  ]
}
