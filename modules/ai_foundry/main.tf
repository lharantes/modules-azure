/**
 * # Azure Ai Foundry (Hub)
 *
 * O Azure AI Foundry é uma oferta unificada de plataforma como serviço do Azure para operações 
 * corporativas de IA, construtores de modelos e desenvolvimento de aplicativos. Essa base combina a
 * infraestrutura de nível de produção com interfaces amigáveis, permitindo que os desenvolvedores se 
 * concentrem na criação de aplicativos em vez de gerenciar a infraestrutura.
 */

resource "azurerm_ai_foundry" "this" {
  # Name: aif-brs-genai-dev
  name                    = lower("aif-${lookup(local.regions, var.location, false)}-${var.service_prefix}-${var.environment}")
  location                = var.location
  resource_group_name     = var.resource_group_name
  storage_account_id      = var.storage_account_id
  key_vault_id            = var.key_vault_id
  application_insights_id = var.application_insights ? azurerm_application_insights.this[0].id : null
  friendly_name           = var.friendly_name != "" ? var.friendly_name : null
  public_network_access   = var.public_network_access
  tags                    = var.tags

  dynamic "managed_network" {
    for_each = var.managed_network != "" ? [1] : []
    content {
      isolation_mode = var.managed_network
    }
  }

  identity {
    type         = var.identity.type
    identity_ids = var.identity.identity_ids
  }
}

resource "azurerm_log_analytics_workspace" "this" {
  count               = var.application_insights ? 1 : 0
  name                = lower("law-${lookup(local.regions, var.location, false)}-${var.service_prefix}-${var.environment}")
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku_log_analytics
  retention_in_days   = var.retention_in_days
}

resource "azurerm_application_insights" "this" {
  count               = var.application_insights ? 1 : 0
  name                = lower("appi-${lookup(local.regions, var.location, false)}-${var.service_prefix}-${var.environment}")
  location            = var.location
  resource_group_name = var.resource_group_name
  workspace_id        = azurerm_log_analytics_workspace.this[count.index].id
  retention_in_days   = var.retention_in_days
  application_type    = var.application_type
  depends_on = [ azurerm_log_analytics_workspace.this ]
}