# Install Kubernetes Dashboard with Ingress
resource "helm_release" "kubernetes_dashboard" {
  name       = "kubernetes-dashboard"
  repository = "https://kubernetes.github.io/dashboard/"
  chart      = "kubernetes-dashboard"
  version    = "7.10.1"
  namespace  = "kubernetes-dashboard"

  create_namespace = true

  set {
    name  = "service.type"
    value = "ClusterIP"
  }

  set {
    name  = "ingress.enabled"
    value = "true"
  }

  set {
    name  = "ingress.annotations.kubernetes\\.io/ingress\\.class"
    value = "nginx"
  }

  set {
    name  = "ingress.hosts[0]"
    value = "dashboard.local"
  }

  set {
    name  = "metricsScraper.enabled"
    value = "true"
  }
}

# Create a ServiceAccount for the dashboard
resource "kubernetes_service_account" "dashboard_sa" {
  metadata {
    name      = "dashboard-admin-sa"
    namespace = "kubernetes-dashboard"
  }
}

# Create a ClusterRoleBinding to grant permissions to the ServiceAccount
resource "kubernetes_cluster_role_binding" "dashboard_role_binding" {
  metadata {
    name = "dashboard-admin-binding"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.dashboard_sa.metadata[0].name
    namespace = "kubernetes-dashboard"
  }
}

# Create a secret for the dashboard ServiceAccount token
resource "kubernetes_secret" "dashboard_secret" {
  metadata {
    name      = "dashboard-sa-token"
    namespace = "kubernetes-dashboard"
    annotations = {
      "kubernetes.io/service-account.name" = kubernetes_service_account.dashboard_sa.metadata[0].name
    }
  }

  type = "kubernetes.io/service-account-token"
}

# Output the dashboard login token
output "dashboard_login_token" {
  value     = kubernetes_secret.dashboard_secret.data["token"]
  sensitive = true
}
