variable "REGION" {
  default = "ap-southeast-2"
}

variable "ZONE1" {
  default = "ap-southeast-2a"
}

#  AWS account details
data "aws_caller_identity" "current" {}