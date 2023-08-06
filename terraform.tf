terraform {
  cloud {
    organization = "Elbalinto"

    workspaces {
      name = "AWS"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.62.0"
    }
  }
  required_version = ">= 0.14.0"
}
