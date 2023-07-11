terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.6.0"
    }
  }
}


provider "aws" {
  # profile = "eksctl"
  region  = "us-east-1"

  access_key = var.provider_aws.access_key
  secret_key = var.provider_aws.secret_key
}