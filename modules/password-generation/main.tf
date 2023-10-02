resource "random_string" "password" {
  length  = var.length
  special = false
}

# Store in secrets manager
resource "aws_secretsmanager_secret" "secret" {
  name                    = var.secret_name
  recovery_window_in_days = 0

  tags = {
    environment = var.env_id
    moniker     = var.purpose_id
    createdby   = "Terraform"
  }
}

resource "aws_secretsmanager_secret_version" "secret" {
  secret_id     = aws_secretsmanager_secret.secret.id
  secret_string = random_string.password.result
}

