module "resourcegroup" {
  source = "./modules/az_resource_group"

  service_prefix = "genai"
  environment    = "prd"
  location       = "eastus2"
}

# module "role_assignments" {
#   source = "./modules/az_role_assignment"

#   role_assignments = [
#     {
#       user_principal_names = ["beatriz@luizsolo.onmicrosoft.com"]
#       role_names           = ["Reader"]
#       scope                = module.resourcegroup.resource_group_id
#     },
#     {
#       user_principal_names = ["julia@luizsolo.onmicrosoft.com"]
#       role_names           = ["Owner"]
#       scope                = module.resourcegroup.resource_group_id
#     }
#   ]
# }

module "sql_server_naming" {
  source = "./modules/az_name_sequence"

  storage_account_name = "stotesttable"
  table_name           = "vms"
  partition_key        = "azpds"
  row_key              = "azpds"
}

module "sql_server" {
  source = "./modules/az_sql_server"

  resource_group_name          = module.resourcegroup.resource_group_name
  administrator_login          = "mysqladmin"
  administrator_login_password = "sfdsfdfsl34243dkslfjkds"
  location                     = "eastus"
  server_version               = "12.0"
  environment                  = "Development"
  suffix                       = module.sql_server_naming.number_suffix
}

module "postgreesql_naming" {
  source = "./modules/az_name_sequence"

  storage_account_name = "stotesttable"
  table_name           = "vms"
  partition_key        = "azpdg"
  row_key              = "azpdg"
}

module "postgreesql" {
  source = "./modules/az_postgreesql"

  location               = "eastus"
  resource_group_name    = module.resourcegroup.resource_group_name
  administrator_login    = "psqladmin"
  administrator_password = "dgdlfgdfjkgkldfgkj45654654"
  server_version         = 16
  sku_name               = "GP_Standard_D2s_v3"
  zone                   = 1
  high_availability = {
    mode                      = "ZoneRedundant"
    standby_availability_zone = 2
  }
  environment = "Production"
  suffix      = module.postgreesql_naming.number_suffix
}

module "mysql_naming" {
  source = "./modules/az_name_sequence"

  storage_account_name = "stotesttable"
  table_name           = "vms"
  partition_key        = "azpdy"
  row_key              = "azpdy"
}

module "mysql_server" {
  source = "./modules/az_mysql"

  location               = "eastus"
  resource_group_name    = module.resourcegroup.resource_group_name
  administrator_login    = "psqladmin"
  administrator_password = "dDDDgdlfgdf4654"
  sku_name               = "GP_Standard_D2ds_v4"
  zone                   = 1
  high_availability = {
    mode                      = "ZoneRedundant"
    standby_availability_zone = 2
  }
  tags = null
  environment = "Quality"
  suffix = module.mysql_naming.number_suffix
}