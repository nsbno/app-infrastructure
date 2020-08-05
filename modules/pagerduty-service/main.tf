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

data "pagerduty_ruleset" "default_global" {
  name = "Default Global"
}

resource "pagerduty_ruleset_rule" "event_rule" {
  ruleset  = data.pagerduty_ruleset.default_global.id
  disabled = "false"

  conditions {
    operator = "and"

    subconditions {
      operator = "contains"
      parameter {
        value = var.service_name
        path  = "payload.component"
      }
    }
  }

  actions {
    route {
      value = pagerduty_service.backend_service.id
    }

    severity {
      value = "critical"
    }
  }
}

