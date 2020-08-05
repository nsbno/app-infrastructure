data "pagerduty_escalation_policy" "default" {
  name = "VY"
}

resource "pagerduty_service" "backend_service" {
  name        = title(var.service_name)
  description = var.description

  escalation_policy = data.pagerduty_escalation_policy.default.id
  alert_creation    = "create_alerts_and_incidents"

  acknowledgement_timeout = "null"
  auto_resolve_timeout    = 86400

  incident_urgency_rule {
    type = "use_support_hours"

    during_support_hours {
      type    = "constant"
      urgency = "high"
    }

    outside_support_hours {
      type    = "constant"
      urgency = "low"
    }
  }

  scheduled_actions {
    to_urgency = "high"
    type       = "urgency_change"

    at {
      name = "support_hours_start"
      type = "named_time"
    }
  }

  support_hours {
    type         = "fixed_time_per_day"
    days_of_week = [1, 2, 3, 4, 5, 6, 7]
    start_time   = "07:00:00"
    end_time     = "23:00:00"
    time_zone    = "Europe/Stockholm"
  }
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
      operator = "equals"
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
  }

  lifecycle {
    ignore_changes = [position]
  }
}

