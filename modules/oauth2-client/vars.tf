variable "vpc_name" {}

variable "env" {}

variable "appname" {}

variable "role_name" {
  default = ""
}

variable "oauth_scopes" {
  type    = list(string)
  default = []
}

variable "store_credentials" {
  default = true
}
