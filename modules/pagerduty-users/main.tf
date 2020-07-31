locals {
  duration_of_oncall = 7 * 24 * 60 * 60 # 7 days
  duration_of_shift  = 16 * 60 * 60     # 16 hours
}

resource "pagerduty_team" "developers" {
  name        = "Omnikanal utviklere"
  description = "Alle utviklere som deltar i vaktordningen for Omnikanal"
}

resource "pagerduty_user" "omnikanal_user" {
  name  = "Jarle Holtan"
  email = "jarle.holtan@vy.no"
}

resource "pagerduty_team_membership" "team_membership" {
  user_id = pagerduty_user.omnikanal_user.id
  team_id = pagerduty_team.omnikanal_dev.id
  role    = "manager"
}

resource "pagerduty_schedule" "default_schedule" {
  name        = "Omnikanal Default Rotation"
  description = "Vaktordning for Vy"
  time_zone   = "Europe/Stockholm"

  layer {
    name                         = "Configuration Layer"
    start                        = ""
    rotation_virtual_start       = ""
    rotation_turn_length_seconds = local.duration_of_oncall

    users = [pagerduty_user.omnikanal_user.id]

    restriction {
      type              = "daily_restriction"
      start_time_of_day = "07:00:00"
      duration_seconds  = local.duration_of_shift
    }
  }
}

resource "pagerduty_escalation_policy" "default" {
  name      = "Default Escalation Policy"
  num_loops = 2
  teams     = [pagerduty_user.omnikanal_user.id]

  rule {
    escalation_delay_in_minutes = 30
    target {
      type = "schedule"
      id   = pagerduty_schedule.default_schedule.id
    }
  }
}
