/**
 * # Azure AI Services
 *
 * Azure AI services help developers and organizations rapidly create intelligent, cutting-edge, market-ready, and responsible applications with out-of-the-box and prebuilt and customizable APIs and models. Example
 * applications include natural language processing for conversations, search, monitoring, translation, speech, vision, and decision-making.
 */


resource "azurerm_ai_services" "this" {
  name                               = lower("aisvc-${lookup(local.regions, var.location, false)}-${var.service_prefix}-${var.environment}")
  location                           = var.location
  resource_group_name                = var.resource_group_name
  sku_name                           = var.sku_name
  local_authentication_enabled       = var.local_authentication_enabled
  outbound_network_access_restricted = var.local_authentication_enabled
  public_network_access              = var.public_network_access
  custom_subdomain_name              = var.custom_subdomain_name != "" ? var.custom_subdomain_name : lower("aisvc-${lookup(local.regions, var.location, false)}-${var.service_prefix}-${var.environment}")

  tags = var.tags

  identity {
    type         = var.identity.type
    identity_ids = var.identity.identity_ids
  }

  dynamic "storage" {
    for_each = var.storage_account != null ? [1] : []
    content {
      storage_account_id = storage.value.storage_account_id
      identity_client_id = storage.value.identity_client_id
    }
  }

}