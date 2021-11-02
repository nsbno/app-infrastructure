variable "appname" {
}

variable "route53_zone" {
}

variable "route53_record_name" {
}

variable "route53_record" {
}

variable "route53_record_ttl" {
}

variable "set_identifier" {
  type    = string
  default = null
}

variable "use_weighted_routing" {
  type    = bool
  default = false
}

variable "weight" {
  type    = number
  default = 100
}
