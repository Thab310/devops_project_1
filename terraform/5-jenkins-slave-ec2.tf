#Create Jenkins slave ec2
resource "aws_instance" "jenkins_slave" {
  ami                  = var.ec2_ami
  instance_type        = "t2.micro"
  subnet_id            = aws_subnet.dev_public_subnet_az1.id
  security_groups      = [aws_security_group.jenkins_slave_sg.id]
  key_name             = local.key_name
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name
  
  tags = {
    Name = "jenkins-slave"
  }

  depends_on = [ aws_iam_instance_profile.ec2_instance_profile ]
}
