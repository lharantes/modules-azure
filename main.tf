module "resourcegroup" {
  source = "./modules/az_resource_group"

  service_prefix = "genai"
  environment    = "prd"
  location = "eastus2"
}

module "role_assignments" {
  source = "./modules/az_role_assignment"

  role_assignments = [
    {
      user_principal_names = ["beatriz@luizsolo.onmicrosoft.com"]
      role_names           = ["Reader"]
      scope                = module.resourcegroup.resource_group_id
    },
    {
      user_principal_names = ["julia@luizsolo.onmicrosoft.com"]
      role_names           = ["Owner"]
      scope                = module.resourcegroup.resource_group_id
    }
  ]
}