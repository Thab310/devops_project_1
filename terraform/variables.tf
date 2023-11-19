variable "environment" {
  description = "name of environment"
  type        = string
}

variable "owner" {
  description = "email of the engineer that is creating these resources"
  type        = string
}

variable "project_name" {
  description = "name of the project"
  type        = string
}

variable "vpc_cidr" {
  description = "vpc cidr block"
  type        = string
}

variable "pub_sub_az1_cidr" {
  description = "public subnet az1 cidr block"
  type        = string
}

variable "pub_sub_az2_cidr" {
  description = "public subnet az2 cidr block"
  type        = string
}

variable "ssh_cidr" {
  description = "range of allowed ip's that can ssh into the 3 instances"
  type        = string
}

variable "port_8080_cidr" {
  description = "range of allowed ip's that are allowed through port 8080 into  jenkins master"
  type        = string
}

variable "port_50000_cidr" {
  description = "range of allowed ip's that are allowed through port 50000 into jenkins slave"
  type        = string
}

variable "ec2_ami" {
  description = "ec2 instance ami"
  type        = string
}

variable "ansible_user" {
  description = "ec2 OS user"
  type        = string
}

variable "jenkins_username" {
  description = "Jenkins login username"
  type        = string
}

variable "jenkins_password" {
  description = "Jenkins login password"
  type        = string
}

variable "jenkins_node_secrets" {
  description = "a map of all key-value secreets in aws sectrets manager"
  type        = map(string)
  sensitive   = true #protect the values of the variable from being printed in the logs and console output
}



