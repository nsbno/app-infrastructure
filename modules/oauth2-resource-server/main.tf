data "aws_cognito_user_pools" "user_pool" {
  name = "${var.vpc_name}-microservice-clients"
}

resource "aws_cognito_resource_server" "resource_server" {
  identifier   = "${var.env}-${var.appname}"
  name         = "${var.env}-${var.appname}"
  user_pool_id = sort(data.aws_cognito_user_pools.user_pool.ids)[0]

  dynamic "scope" {
    for_each = var.oauth_scopes
    content {
      scope_name = scope.value["name"]
      scope_description = scope.value["description"]
    }
  }
}