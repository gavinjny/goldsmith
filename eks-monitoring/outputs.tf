data "kubernetes_service" "grafana" {
  metadata {
    name      = "${helm_release.kps.name}-grafana"
    namespace = "monitoring"
  }
  depends_on = [helm_release.kps]
}

output "grafana_url" {
  description = "Visit once the LoadBalancer hostname appears"
  value       = "http://${try(data.kubernetes_service.grafana.status[0].load_balancer[0].ingress[0].hostname, "")}"
}

output "grafana_admin_user" {
  value       = "admin"
  sensitive   = true
  description = "Grafana admin username"
}

output "grafana_admin_password" {
  value       = random_password.grafana.result
  sensitive   = true
  description = "Grafana admin password"
}
