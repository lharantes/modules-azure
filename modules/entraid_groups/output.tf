output "group_objecti_id" {
  value = azuread_group.this.object_id
}

output "group_name" {
  value = azuread_group.this.display_name
}