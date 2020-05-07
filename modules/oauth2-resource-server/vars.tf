variable "vpc_name" {}

variable "env" {}

variable "appname" {}

variable "oauth_scopes" {
  type = list(object({
    name        = string
    description = string
  }))
}
