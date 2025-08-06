data "azurerm_client_config" "current" {}

variable "service_prefix" {
  default = "genai"
}

resource "azurerm_resource_group" "example" {
  name     = "rg-test-genai"
  location = "eastus2"
}

resource "azurerm_key_vault" "example" {
  name                      = "kv-arantes-test"
  location                  = azurerm_resource_group.example.location
  resource_group_name       = azurerm_resource_group.example.name
  tenant_id                 = data.azurerm_client_config.current.tenant_id
  enable_rbac_authorization = true
  sku_name                  = "standard"
  purge_protection_enabled  = true
}

resource "azurerm_storage_account" "example" {
  name                     = "stoarantesgenai"
  location                 = azurerm_resource_group.example.location
  resource_group_name      = azurerm_resource_group.example.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_virtual_network" "main" {
  name                = "${var.service_prefix}-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}

module "log_analytics" {
  source = "./az_log_analytics_workspace"
  resource_group_name     = azurerm_resource_group.example.name
  location                = azurerm_resource_group.example.location
  environment             = "dev"
  service_prefix          = var.service_prefix
  retention_in_days = 30
  sku_log_analytics = "PerGB2018"
}

module "application_insights" {
  source = "./az_application_insights"
  resource_group_name     = azurerm_resource_group.example.name
  location                = azurerm_resource_group.example.location
  environment             = "dev"
  service_prefix          = var.service_prefix
  log_analytics_workspace = module.log_analytics.log_analytics_id
}

module "foundry" {
  source                  = "./ai_foundry"
  resource_group_name     = azurerm_resource_group.example.name
  location                = azurerm_resource_group.example.location
  environment             = "dev"
  service_prefix          = var.service_prefix
  key_vault_id            = azurerm_key_vault.example.id
  storage_account_id      = azurerm_storage_account.example.id
  application_insights_id = module.application_insights.application_insights_id
  enable_private_endpoint = true
  subnet_id               = azurerm_subnet.internal.id
  identity = {
    type = "SystemAssigned"
  }
}

module "project" {
  source         = "./ai_project"
  location       = azurerm_resource_group.example.location
  environment    = "dev"
  service_prefix = var.service_prefix
  hub_id         = module.foundry.ai_foundry_id
  identity = {
    type = "SystemAssigned"
  }
}

module "ai_services" {
  source                  = "./ai_services"
  resource_group_name     = azurerm_resource_group.example.name
  location                = azurerm_resource_group.example.location
  environment             = "dev"
  service_prefix          = var.service_prefix
  sku_name                = "S0"
  enable_private_endpoint = true
  subnet_id               = azurerm_subnet.internal.id
  identity = {
    type = "SystemAssigned"
  }
}

module "ai_search_services" {
  source                        = "./ai_search_service"
  resource_group_name           = azurerm_resource_group.example.name
  location                      = azurerm_resource_group.example.location
  environment                   = "dev"
  service_prefix                = var.service_prefix
  public_network_access_enabled = false
  enable_private_endpoint       = false
  sku                           = "standard"
  partition_count               = 1
  replica_count                 = 1
  semantic_search_sku           = "standard"
  hosting_mode                  = "default"
}