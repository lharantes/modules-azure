data "azuread_users" "users" {
  user_principal_names = var.owners
}

resource "azuread_group" "this" {
  display_name            = var.group_name
  owners                  = data.azuread_users.users.object_ids
  security_enabled        = var.security_enabled
  assignable_to_role      = var.assignable_to_role
  prevent_duplicate_names = true
}