locals {
  duration_of_oncall = 7 * 24 * 60 * 60 # 7 days
  duration_of_shift  = 16 * 60 * 60     # 16 hours
}

#resource "pagerduty_team" "developers" {
#  name        = "Omnikanal utviklere"
#  description = "Alle utviklere som deltar i vaktordningen for Omnikanal"
#}

data "pagerduty_user" "users" {
  for_each = toset(var.users)
  email    = each.value
}

#resource "pagerduty_team_membership" "team_membership" {
#  for_each = data.pagerduty_user.users
#  team_id  = pagerduty_team.developers.id
#  user_id  = each.value.id
#  role     = "manager"
#}

resource "pagerduty_schedule" "default_schedule" {
  name        = "Omnikanal Default Rotation"
  description = "Vaktordning for Vy"
  time_zone   = "Europe/Stockholm"

  layer {
    name                         = "Configuration Layer"
    start                        = var.rotation_start_time
    rotation_virtual_start       = var.rotation_start_time
    rotation_turn_length_seconds = local.duration_of_oncall

    users = values(data.pagerduty_user.users)[*].id

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
  #teams     = [pagerduty_team.developers.id]

  rule {
    escalation_delay_in_minutes = 30
    target {
      type = "schedule_reference"
      id   = pagerduty_schedule.default_schedule.id
    }
  }
}
