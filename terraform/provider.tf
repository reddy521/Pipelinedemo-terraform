

# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}

  subscription_id = "8427562f-8418-42ba-bd2d-f267f0f59639"
  client_id       = "43f51cb4-790e-4001-b469-9a0f946db138"
  client_secret   = "ThR8Q~6r4Pmsr0Cq20FXug0y5rt1h9fE0Hl2rchB"
  tenant_id       = "aa60563d-ee7f-4224-bfb1-b4b18151ed8a"
}        #        6gt8Q~~Y-cHVx9VqIKtZxgU4gycCK86D6GS9CcAl

    





# Using Azure Storage Container to store state file instead of remote backend from terraform

terraform {
  backend "azurerm" {
    resource_group_name  = "var.resource_group_name"
    storage_account_name = "azure-scale-set"
    container_name       = "tfstate"
    key                  = "testing001"
  }
}


# # Using Terraform Workspace:
# terraform {
#   backend "remote" {
#     hostname     = "app.terraform.io"
#     organization = "organization-value-id"

#     workspaces {
#       name = "workstation-value-id"
#     }
#   }
# }
