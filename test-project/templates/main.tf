terraform {
  required_version = ">=1.3.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.24.0"
    }
    azapi = {
      source  = "azure/azapi"
      version = "=0.6.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "terraform-example-dev-rg" // ToDo: tfstate-dev-rg
    storage_account_name = "tfexst" // ToDo: tfstatedevrg
    container_name       = "tf-ex-state" // ToDo: tfstate
    // The Filename in the Container
    key                  = "dev.terraform.tfstate"
  }
}

// Configure Provider for Microsoft Azure using Azure Resource Manager API's.
provider "azurerm" {
  // See default behavior https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/features-block
  features {}
}

// Configure Provider Azure ARM REST APIs - https://registry.terraform.io/providers/azure/azapi/latest/docs
// Reference see: https://learn.microsoft.com/en-us/azure/templates/
// Example see: https://github.com/Azure/terraform-provider-azapi/tree/main/examples
provider "azapi" {
}

locals {
  tags = {
    environment   = var.environment
    application   = "example"
    location      = var.resource_location
    automation    = "terraform"
  }
}

## Sample with azurerm

resource "azurerm_resource_group" "abc-rg" {
  name     = "abc-${var.environment}-rg"
  location = var.resource_location

  tags = merge(local.tags, {
    provider = "azurerm"
  })
}

// https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account
resource "azurerm_storage_account" "abclskdj8-st" {
  name                              = "abclskdj8${var.environment}st"
  resource_group_name               = azurerm_resource_group.abc-rg.name
  location                          = var.resource_location
  account_tier                      = "Premium"
  account_replication_type          = "LRS"
  account_kind                      = "BlockBlobStorage"
  access_tier                       = "Cool"
  min_tls_version                   = "TLS1_2"
  public_network_access_enabled     = true
  shared_access_key_enabled         = true
  // Hierarchical Namespace
  is_hns_enabled                    = true

  network_rules {
    bypass                          = [ "Metrics", "AzureServices" ]
    default_action                  = "Allow"
  }

  enable_https_traffic_only         = true

  tags = merge(local.tags, {
    provider = "azurerm"
  })
}

## Sampl with azapi

// Use this data source to access the configuration of the AzureRM provider https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config
data "azurerm_client_config" "current" {
}

resource "azapi_resource" "test" {
  type = "Microsoft.Resources/resourceGroups@2021-04-01"
  name = "abc2-${var.environment}-rg"
  location = var.resource_location
  parent_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"

  tags = merge(local.tags, {
    provider = "azapi"
  })
}


resource "azapi_resource" "abc2lskdj8-st" {
  type = "Microsoft.Storage/storageAccounts@2022-05-01"
  name = "abc2lskdj8${var.environment}st"
  location = var.resource_location
  parent_id = azapi_resource.test.id
  tags = merge(local.tags, {
    provider = "azapi"
  })

  body = jsonencode({
    properties = {
      accessTier = "Cool"
      allowBlobPublicAccess = true
      allowSharedKeyAccess = true
      encryption = {
        keySource = "Microsoft.Storage"
        services = {
          blob = {
            enabled = true
            keyType = "Account"
          }
          file = {
            enabled = true
            keyType = "Account"
          }
        }
      }
      isHnsEnabled = true
      minimumTlsVersion = "TLS1_2"
      networkAcls = {
        bypass = "Metrics, AzureServices"
        defaultAction = "Allow"
        ipRules = []
        virtualNetworkRules = []
      }
      supportsHttpsTrafficOnly = true
    }
    sku = {
      name = "Premium_LRS"
    }
    kind = "BlockBlobStorage"
  })
}
