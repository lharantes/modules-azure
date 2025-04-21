terraform {
  required_version = ">= 1.9, < 2.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.117, < 5.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "3.3.0"
    }
  }
}

