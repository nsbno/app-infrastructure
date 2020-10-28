terraform {
  required_providers {
    pagerduty = {
      source  = "pagerduty/pagerduty"
      version = ">= 1.7.10"
    }
  }
  required_version = ">= 0.13"
}
