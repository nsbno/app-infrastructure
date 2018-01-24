variable "domain" {}
variable "aliases" { type = "list" }
variable "origin_id" {}
variable "origin_domain_name" {}
variable "default_root_object" { default = "index.html" }
variable "default_ttl" { default = "3600" }
variable "max_ttl" { default = "86400" }
