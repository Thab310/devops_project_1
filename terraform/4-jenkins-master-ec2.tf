#Create Jenkins master ec2
resource "aws_instance" "jenkins_master" {
  ami             = var.ec2_ami
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.dev_public_subnet_az1.id
  security_groups = [aws_security_group.jenkins_master_sg.id]
  key_name        = local.key_name

  tags = {
    Name = "jenkins-master"
  }
}
