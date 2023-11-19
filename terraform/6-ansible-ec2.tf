#Upload pub ssh key
resource "aws_key_pair" "tp_key" {
  key_name   = local.key_name
  public_key = file(local.public_key_path) //local.public_key_path // check out
}

#Create Ansible ec2
resource "aws_instance" "ansible" {
  ami             = var.ec2_ami
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.dev_public_subnet_az1.id
  security_groups = [aws_security_group.ansible_sg.id]
  key_name        = local.key_name
  depends_on      = [aws_key_pair.tp_key, aws_secretsmanager_secret_version.secrets]

  //copy ssh key into ec2 instance
  provisioner "file" {
    source      = local.private_key_path
    destination = "/home/ubuntu/${local.key_name}"
  }

  //copy jenkins master ansible-playbook to ec2 instance
  provisioner "file" {
    source      = "../ansible/jenkins-master-setup.yaml"
    destination = "/home/ubuntu/jenkins-master-setup.yaml"
  }

  //copy jenkins master bash script
  provisioner "file" {
    source      = "../userdata/get-InitialPassword.sh"
    destination = "/tmp/get-InitialPassword.sh"
  }

  //copy jenkins slave ansible-playbook to ec2 instance
  provisioner "file" {
    source      = "../ansible/jenkins-slave-setup.yaml"
    destination = "/home/ubuntu/jenkins-slave-setup.yaml"
  }

  //copy jenkins slave bash script
  provisioner "file" {
    source      = "../userdata/jenkins-node.sh"
    destination = "/tmp/jenkins-node.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install -y software-properties-common",
      "sudo add-apt-repository --yes --update ppa:ansible/ansible",
      "sudo apt install -y ansible",
      "sudo mv ${local.key_name} /opt",
      "sudo mv jenkins-master-setup.yaml /opt",
      "sudo mv jenkins-slave-setup.yaml /opt",
      "cd /opt && touch hosts ",
      "sudo chmod 400 ${local.key_name}",

      #update ansible inventory file 
      //master
      "echo '[jenkins-master]' | sudo tee -a hosts",
      "echo '${aws_instance.jenkins_master.private_ip}' | sudo tee -a hosts",
      "echo '[jenkins-master:vars]' | sudo tee -a hosts",
      "echo 'ansible_user=${var.ansible_user}' | sudo tee -a hosts",
      "echo 'ansible_ssh_private_key_file=/opt/${local.key_name}' | sudo tee -a hosts",
      //slave
      "echo '[jenkins-slave]' | sudo tee -a hosts",
      "echo '${aws_instance.jenkins_slave.private_ip}' | sudo tee -a hosts",
      "echo '[jenkins-slave:vars]' | sudo tee -a hosts",
      "echo 'ansible_user=${var.ansible_user}' | sudo tee -a hosts",
      "echo 'ansible_ssh_private_key_file=/opt/${local.key_name}' | sudo tee -a hosts",

      "echo 'jenkins_url=${aws_instance.jenkins_master.public_ip}' | sudo tee -a hosts",
      "echo 'jenkins_username=${var.jenkins_username}' | sudo tee -a hosts",
      "echo 'jenkins_password=${var.jenkins_password}' | sudo tee -a hosts",
      "echo 'device_name=eth0' | sudo tee -a hosts",

      "echo '[defaults]' | sudo tee -a /etc/ansible/ansible.cfg",
      "echo 'host_key_checking = False' | sudo tee -a /etc/ansible/ansible.cfg",

      //run ansible playbooks
      "ansible-playbook -i /opt/hosts jenkins-master-setup.yaml",
      "ansible-playbook -i /opt/hosts jenkins-slave-setup.yaml"
    ]
  }

  // ssh connection in order to run commands
  connection {
    type        = "ssh"
    user        = local.user
    private_key = file(local.private_key_path)
    host        = self.public_ip
    timeout     = "4"
  }

  tags = {
    Name = "ansible"
  }

}

output "ansible_instance_ip" {
  value = aws_instance.ansible.public_ip
}
