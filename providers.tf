terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.27.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.7.2"
    }
  }
  required_version = "~>1.14.0"
}

provider "aws" {
  region = "us-east-1"
  # Agregando el access y el secret key, terraform se podra conectar a nuestra cuenta de AMAZON
  access_key = var.access_key
  secret_key = var.secret_key
  default_tags {
    tags = var.tags
  }
}