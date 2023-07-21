terraform {
  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "0.47.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.5.1"
    }
  }
required_version = "~> 1.1"
}
