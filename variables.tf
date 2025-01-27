variable "kube_config" {
    description = "Path to the kubeconfig file"
    default = pathexpand("~/.kube/config")
}