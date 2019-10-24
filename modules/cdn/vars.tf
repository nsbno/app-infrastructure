variable "domain" {
}

variable "aliases" {
  type = list(string)
}

variable "origin_id" {
}

variable "origin_domain_name" {
}

variable "default_root_object" {
  default = "index.html"
}

variable "default_ttl" {
  default = "3600"
}

variable "max_ttl" {
  default = "86400"
}

variable "origin_access_identity" {
  default = ""
}

