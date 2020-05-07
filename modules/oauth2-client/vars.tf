variable "vpc_name" {}

variable "env" {}

variable "appname" {}

variable "oauth_scopes" {
  type = list(string)
  default = []
}
