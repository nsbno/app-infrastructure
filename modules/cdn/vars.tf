variable "domain" {}
variable "aliases" { type = "list" }
variable "origin_id" {}
variable "origin_domain_name" {}
variable "default_root_object" { default = "index.html" }
