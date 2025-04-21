module "resourcegroup" {
  source = "./modules/az_resource_group"

  service_prefix = "genai"
  environment    = "prd"
}