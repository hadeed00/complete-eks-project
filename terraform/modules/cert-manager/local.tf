locals {
    chart_values = {
        cert_manager_namespace   = "cert-manager"
        installCRDs              = true
        createNamespace          = true
        namespace                = "cert-manager"
        clusterResourceNamespace = "cert-manager"
    }
}