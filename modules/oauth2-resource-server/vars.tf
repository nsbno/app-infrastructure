variable "appname" {
  type = string
}

variable "oauth_scopes" {
  type = list(object({
    name        = string
    description = string
  }))
}

variable "user_pool_id" {
  type = string
}
