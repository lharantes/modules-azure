resource "azurerm_mysql_flexible_server_active_directory_administrator" "this" {
  # only create the resource if the user has supplied parameters to var.active_directory_administrator.
  count = var.active_directory_administrator != null ? 1 : 0

  identity_id = coalesce(var.active_directory_administrator.identity_id, azurerm_mysql_flexible_server.this.identity[0].identity_ids)
  login       = var.active_directory_administrator.login
  object_id   = var.active_directory_administrator.object_id
  server_id   = azurerm_mysql_flexible_server.this.id
  tenant_id   = var.active_directory_administrator.tenant_id
}
