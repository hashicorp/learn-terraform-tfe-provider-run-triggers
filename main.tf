terraform {
  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "0.22.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "2.3.0"
    }
  }
}
