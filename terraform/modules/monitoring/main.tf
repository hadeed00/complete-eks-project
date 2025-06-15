resource "helm_release" "kube_prometheus_stack" {
  name       = "kube-prometheus-stack"
  chart      = "kube-prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  version    = "73.1.0"
  namespace  = "monitoring"
  create_namespace = true

  values = [yamlencode(local.chart_values)]
}
