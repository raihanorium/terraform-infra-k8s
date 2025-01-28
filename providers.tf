terraform {
  required_providers {
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

provider "kubernetes" {
  config_path = pathexpand(var.kube_config)
}

provider "helm" {
  kubernetes = {
    config_path = pathexpand(var.kube_config)
  }
}