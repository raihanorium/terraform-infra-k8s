resource "kind_cluster" "kind-cluster" {
  name = "k8s-cluster"
  kubeconfig_path = pathexpand(var.kube_config)
  node_image = "kindest/node:v1.27.1"
  wait_for_ready = true

  kind_config {
    kind = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"

    node {
      role = "control-plane"
    }
    node {
      role =  "worker"
    }
    node {
      role =  "worker"
    }
  }
}