locals {
  chart_values = {
    grafana = {
      adminPassword = "admin123"
    }

    alertmanager = {
      config = {
        global ={
          smtp_smarthost = "mail.park-notify.com:465"
          smtp_from = "hadeed-test@park-notify.com"
          smtp_auth_username = "hadeed-test@park-notify.com"
          smtp_auth_password = "123645678!12345678"
          smtp_require_tls = true
        }
        route = {
          group_by = ["alertname", "cluster", "namespace"]
          group_wait = "30s"
          group_interval = "5m"
          repeat_interval = "12h"
          receiver = "email-notifications"
        }
        receivers = [{
          name = "email-notifications"
          email_configs = [{
            to = "hhh011@hotmail.co.uk"
          }]
        }]
      }
      enabled = true
        alertmanagerSpec = {
            additionalArgs = [{
                name  = "auto-gomemlimit.ratio"
                value = "0.9"                # The additional args feature was introduced upstream by myself.
            }]
        }
      enableFeatures = ["auto-gomemlimit"]
    }
  }
}
