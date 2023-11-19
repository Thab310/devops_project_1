#Jenkins Slave IAM Role
resource "aws_iam_role" "jenins_node_role" {
  name = "ec2_get_secrets"

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
}

#Jenkins Slave Instance Profile
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "jenkins-node-ec2"
  role = aws_iam_role.jenins_node_role.name
}