terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "2.5.1"
      # Using this version to get rid of the issue https://github.com/helm/helm/issues/10975
    }
  }
}