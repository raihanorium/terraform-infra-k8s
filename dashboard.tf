resource "helm_release" "kubernetes_dashboard" {
  depends_on = [kind_cluster.kind-cluster]
  name       = "kubernetes-dashboard"
  repository = "https://kubernetes.github.io/dashboard/"
  chart      = "kubernetes-dashboard"
  version    = "7.10.1"
  namespace  = "kubernetes-dashboard"

  create_namespace = true
}

