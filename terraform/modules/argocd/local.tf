locals {
  chart_values = {
    argocd = {
      crds = {
        install = true
      }
      server = {
        service = {
          type = "LoadBalancer"
        }
      }
    }
  }
}