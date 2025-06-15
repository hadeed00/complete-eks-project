terraform {
  required_version = ">= 1.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23"
    }
     kubectl = {
      source  = "alekc/kubectl"
      version = ">= 2.0.2"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">=2.5.0"
    }
  }
  backend "s3" {
    bucket = "flask-eks-terraform-state"
    key    = "eks-project/terraform.tfstate"
    region = "eu-west-2"
  }
}
