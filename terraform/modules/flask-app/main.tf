resource "helm_release" "flask_app" {
  chart      = "./../../../helm/flask-app"
  name       = "flask"
  namespace  = "default"
  values     = [yamlencode(local.chart_values)]
}