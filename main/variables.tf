variable "aws_access_key" {
}

variable "aws_secret_key" {
}

variable "azs" {
  type        = map(list(string))
  description = "Availability zones by region"
  default = {
    ap-southeast-1 = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
  }
}