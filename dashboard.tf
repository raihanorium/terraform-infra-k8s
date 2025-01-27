# Install Kubernetes Dashboard with Ingress
resource "helm_release" "kubernetes_dashboard" {
  name       = "kubernetes-dashboard"
  repository = "https://kubernetes.github.io/dashboard/"
  chart      = "kubernetes-dashboard"
  version    = "7.10.1"
  namespace  = "kubernetes-dashboard"

  create_namespace = true
}

