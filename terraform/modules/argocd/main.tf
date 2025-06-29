resource "helm_release" "argocd" {
  name       = "argocd"
  namespace  = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "8.1.1"
  values = [yamlencode(local.chart_values)]

  create_namespace = true
}

resource "null_resource" "wait_for_crds" {
  depends_on = [helm_release.argocd]

  provisioner "local-exec" {
    command = <<EOT
      aws eks --region eu-west-2 update-kubeconfig --name flask-eks-project
      echo "Waiting for ArgoCD CRDs to become available..."
      for i in {1..30}; do
        kubectl get crd applications.argoproj.io && exit 0
        echo "CRD not ready yet. Retrying in 5s..."
        sleep 5
      done
      echo "CRD did not become ready in time." >&2
      exit 1
    EOT
  }
}

resource "null_resource" "argocd_app" {
  depends_on = [null_resource.wait_for_crds]

  provisioner "local-exec" {
    command = "aws eks --region eu-west-2 update-kubeconfig --name flask-eks-project && kubectl apply -f ${path.module}/resources/argocd-app.yaml"
  }
}