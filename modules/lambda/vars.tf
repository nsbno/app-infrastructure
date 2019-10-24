variable "vpc_name" {
}

variable "filename" {
}

variable "function_name" {
}

variable "description" {
}

variable "handler" {
}

variable "runtime" {
}

variable "publish" {
}

variable "security_group_ids" {
  type = list(string)
}

variable "availability_zones" {
  type = list(string)
}

variable "account_id" {
}

variable "environment" {
  type = map(string)
}

