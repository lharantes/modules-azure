resource "azurerm_private_endpoint" "this" {
  for_each = var.private_endpoints

  location                      = coalesce(each.value.location, var.location)
  name                          = each.value.name != null ? each.value.name : "pe-${lower("azpdy${lookup(local.environment, var.environment, false)}${format("%04d", var.suffix)}")}"
  resource_group_name           = each.value.resource_group_name != null ? each.value.resource_group_name : var.resource_group_name
  subnet_id                     = each.value.subnet_resource_id
  custom_network_interface_name = each.value.network_interface_name
  tags                          = each.value.tags

  private_service_connection {
    is_manual_connection           = false
    name                           = each.value.private_service_connection_name != null ? each.value.private_service_connection_name : "pse-${lower("azpdy${lookup(local.environment, var.environment, false)}${format("%04d", var.suffix)}")}"
    private_connection_resource_id = azurerm_mysql_flexible_server.this.id
    subresource_names              = ["mysqlServer"]
  }
  dynamic "ip_configuration" {
    for_each = each.value.ip_configurations

    content {
      name               = ip_configuration.value.name
      private_ip_address = ip_configuration.value.private_ip_address
      member_name        = "mysqlServer"
      subresource_name   = "mysqlServer"
    }
  }
  dynamic "private_dns_zone_group" {
    for_each = length(each.value.private_dns_zone_resource_ids) > 0 ? ["this"] : []

    content {
      name                 = each.value.private_dns_zone_group_name
      private_dns_zone_ids = each.value.private_dns_zone_resource_ids
    }
  }
}

resource "azurerm_private_endpoint_application_security_group_association" "this" {
  for_each = local.private_endpoint_application_security_group_associations

  application_security_group_id = each.value.asg_resource_id
  private_endpoint_id           = azurerm_private_endpoint.this[each.value.pe_key].id
}
