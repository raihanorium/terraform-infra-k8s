terraform {
  required_providers {
    kind = {
      source = "tehcyx/kind"
      version = "0.7.0"
    }

    helm = {
      source = "hashicorp/helm"
      version = "3.0.0-pre1"
    }
  }
}
provider "kind" {}

provider "helm" {
  kubernetes {
    config_path = var.kube_config
  }
}