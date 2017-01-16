variable "elb_name" {}
variable "vpc_id" {}
variable "public_subnet_ids" { type = "list" }
variable "app_ids" { type = "list" }
variable "elb_sg" {}
variable "healthcheck_target" {}
variable "ssl_cert_arn" {}
