variable "env_id" {
  description = "Unique id for the environment"
}

variable "length" {
  description = "Length of password"
  default     = 16
}

variable "purpose_id" {
  description = "Purpose for the DB"
}

variable "secret_name" {
  description = "Name to use for the secret in Secrets Manager"
}

