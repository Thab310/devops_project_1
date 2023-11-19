#AWS Secrets Manager
resource "aws_secretsmanager_secret" "secrets" {
  name                    = "jenkins-node-secrets"
  recovery_window_in_days = 0 //Force deletion without recovery
}

resource "aws_secretsmanager_secret_version" "secrets" {
  secret_id     = aws_secretsmanager_secret.secrets.id
  secret_string = jsonencode(var.jenkins_node_secrets)
}

#AWS Secrets Manager Resource Policy
data "aws_iam_policy_document" "secrets_policy" {
  statement {
    sid    = "EnableEc2ToReadTheSecret"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.jenins_node_role.arn]
    }

    actions   = ["secretsmanager:GetSecretValue"]
    resources = ["*"]
  }
}

#AWS Secrets Manager Resource Policy
resource "aws_secretsmanager_secret_policy" "secrets_policy" {
  secret_arn = aws_secretsmanager_secret.secrets.arn
  policy     = data.aws_iam_policy_document.secrets_policy.json
}