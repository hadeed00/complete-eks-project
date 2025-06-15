locals {
  chart_values = {
    controller = {
      ingressClassResource = {
        name    = "nginx"
        enabled = true
        default = true
      }
      service = {
        annotations = {
          "service.beta.kubernetes.io/aws-load-balancer-type" = "nlb"
        }
        type = "LoadBalancer"
      }
    }
  }
}