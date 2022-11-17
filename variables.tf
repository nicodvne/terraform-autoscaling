variable "aws_region" {
  type        = string
  description = "AWS Region"
}

variable "vpc_name" {
  type = string
  description = "Nom de la région"
}

module "discovery" {
  source = "github.com/Lowess/terraform-aws-discovery"
  vpc_name = "${var.vpc_name}"
  aws_region = var.aws_region
}

variable availability_zones {
  type = map(string)
  default = {
    "f" = 0,
    "a" = 1,
  }
  
}

variable environment {
  type = string
  description = "Label environnement du VPC"
}

variable amiId {
  type = string
  description = "Instance AMI ID"
}
