locals {
  chart_values = {
    grafana = {
      ingress = {
        enabled = true
        annotations = {
          "nginx.ingress.kubernetes.io/rewrite-target" = "/"
        }
        ingressClassName = "nginx"
        hosts = ["grafana.default.svc.cluster.local"]
        paths = ["/grafana"]
        pathType = "Prefix"
      }
      adminPassword = "admin123"
    }

    alertmanager = {
      enabled = true
        alertmanagerSpec = {
            additionalArgs = [{
                name  = "auto-gomemlimit.ratio"
                value = "0.9"                # The additional args feature was introduced upstream by myself.
            }]
        }
      enableFeatures = ["auto-gomemlimit"]
      ingress = {
        enabled = true
        annotations = {
          "nginx.ingress.kubernetes.io/rewrite-target" = "/"
        }
        ingressClassName = "nginx"
        hosts = ["alertmanager.default.svc.cluster.local"]
        paths = ["/alertmanager"]
        pathType = "Prefix"
      }
    }
  }
}
