variable "vpc_id" {}
variable "number_of_public_subnets" {}
variable "zones" { type = "map" }
variable "public_subnets_cidr_blocks" { type = "map" }
variable "internet_gateway_id" {}
