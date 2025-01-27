terraform {
  required_providers {
    kind = {
      source = "tehcyx/kind"
      version = "0.7.0"
    }

    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.35.1"
    }

    helm = {
      source = "hashicorp/helm"
      version = "3.0.0-pre1"
    }
  }
}
provider "kind" {}

provider "kubernetes" {
  config_path = pathexpand(var.kube_config)
}

provider "helm" {
  kubernetes = {
    config_path = pathexpand(var.kube_config)
  }
}