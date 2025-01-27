resource "helm_release" "kubernetes_dashboard" {
  depends_on = [kind_cluster.kind-cluster]
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

resource "kubernetes_cluster_role_binding" "dashboard_admin" {
  depends_on = [kind_cluster.kind-cluster]

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
    name = "kubernetes-dashboard-web"
    namespace  = "kubernetes-dashboard"
  }

  provisioner "local-exec" {
    command = "sleep 15"
  }
}

data "kubernetes_secret" "dashboard-admin" {
  depends_on = [kubernetes_cluster_role_binding.dashboard_admin]

  metadata {
    name = kubernetes_cluster_role_binding.dashboard_admin.subject[0].name
    namespace  = "kubernetes-dashboard"
  }
}