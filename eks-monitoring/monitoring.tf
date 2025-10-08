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
  # version  = "65.5.0" # optional pin

  # Minimal demo-friendly values
  set { name = "grafana.adminUser",             value = "admin" }
  set { name = "grafana.adminPassword",         value = random_password.grafana.result }
  set { name = "grafana.service.type",          value = "LoadBalancer" }
  set { name = "grafana.persistence.enabled",   value = "false" } # ephemeral for demo

  depends_on = [module.eks]
}
