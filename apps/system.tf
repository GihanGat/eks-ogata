provider "aws" {
  region = "ca-central-1"
}

provider "helm" {
  kubernetes {
    #config_path = "/tmp/kube/config"
    config_path = "C:/Users/gihan/.kube/config"
  }
}

provider "kubernetes" {
  #config_path = "/tmp/kube/config"
  config_path = "C:/Users/gihan/.kube/config"
}

data "terraform_remote_state" "ogata_infra" {
  backend = "s3"
  config = {
    bucket = "terraform-ogata-com"
    key    = "infra.tfstate"
    region = "ca-central-1"
  }
}

terraform {
  backend "s3" {
    bucket = "terraform-ogata-com"
    key    = "apps.tfstate"
    region = "ca-central-1"
  }
}