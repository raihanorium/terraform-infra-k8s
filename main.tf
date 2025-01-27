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
      kubeadm_config_patches = [
        "kind: InitConfiguration\nnodeRegistration:\n  kubeletExtraArgs:\n    node-labels: \"ingress-ready=true\"\n"
      ]
      extra_port_mappings {
        container_port = 80
        host_port = 8080
      }
      extra_port_mappings {
        container_port = 443
        host_port = 40443
      }
    }
    node {
      role =  "worker"
    }
    node {
      role =  "worker"
    }
  }
}