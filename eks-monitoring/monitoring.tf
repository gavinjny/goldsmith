resource "kubernetes_namespace" "monitoring" {
  metadata { name = "monitoring" }
}

resource "random_password" "grafana" {
  length  = 20
  special = true
}

resource "helm_release" "kps" {
  name       = "kps"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"

  values = [
    yamlencode({
      grafana = {
        adminUser     = "admin"
        adminPassword = random_password.grafana.result
        service       = { type = "LoadBalancer" }
        persistence   = { enabled = false }
      }
    })
  ]

  depends_on = [module.eks]
}
