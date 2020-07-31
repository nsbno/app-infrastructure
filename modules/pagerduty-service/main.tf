data "pagerduty_escalation_policy" "default" {
  name = "Default Escalation Policy"
}

resource "pagerduty_service" "backend_service" {
  name        = var.service_name
  description = var.description

  escalation_policy = data.pagerduty_escalation_policy.default.id
  alert_creation    = "create_alerts_and_incidents"

  alert_grouping         = "time"
  alert_grouping_timeout = 2
}

data "pagerduty_vendor" "cloudwatch" {
  name = "Cloudwatch"
}

resource "pagerduty_service_integration" "cloudwatch_integration" {
  name    = "Cloudwatch"
  service = pagerduty_service.backend_service.id
  vendor  = data.pagerduty_vendor.cloudwatch.id
}
