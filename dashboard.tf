resource "helm_release" "kubernetes_dashboard" {
  name       = "kubernetes-dashboard"
  repository = "https://kubernetes.github.io/dashboard/"
  chart      = "kubernetes-dashboard"
  version    = "7.10.1"
  namespace  = "kubernetes-dashboard"
  create_namespace = true
  values = [
    file("./dashboard-values.yaml")
  ]

  lifecycle {
    prevent_destroy = false
  }
}

resource "kubernetes_service_account" "dashboard_admin" {
  depends_on = [helm_release.kubernetes_dashboard]

  metadata {
    name      = "dashboard-admin"
    namespace  = "kubernetes-dashboard"
  }

  provisioner "local-exec" {
    command = "sleep 20"
  }
}

resource "kubernetes_cluster_role_binding" "dashboard_admin" {
  depends_on = [helm_release.kubernetes_dashboard]

  metadata {
    name = "dashboard_admin"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "ServiceAccount"
    name = "dashboard-admin"
    namespace  = "kubernetes-dashboard"
  }

  provisioner "local-exec" {
    command = "sleep 15"
  }
}

data "kubernetes_secret" "dashboard-admin" {
  depends_on = [kubernetes_service_account.dashboard_admin]

  metadata {
    name = kubernetes_service_account.dashboard_admin.default_secret_name
    namespace  = "kubernetes-dashboard"
  }
}