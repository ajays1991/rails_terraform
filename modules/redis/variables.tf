variable "environment" {
  description = "The environment"
}

variable "subnet_ids" {
  type        = list
  description = "Subnet ids"
}

variable "vpc_id" {
  description = "The VPC id"
}