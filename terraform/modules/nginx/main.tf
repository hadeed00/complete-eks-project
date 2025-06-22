resource "helm_release" "nginx_ingress" {
  chart      = "ingress-nginx"
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  values = [yamlencode(local.chart_values)]
  version    = "4.10.0"  
}


