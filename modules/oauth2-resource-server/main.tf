resource "aws_cognito_resource_server" "resource_server" {
  identifier   = var.appname
  name         = var.appname
  user_pool_id = var.user_pool_id

  dynamic "scope" {
    for_each = var.oauth_scopes
    content {
      scope_name        = scope.value["name"]
      scope_description = scope.value["description"]
    }
  }
}