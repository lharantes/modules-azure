<!-- BEGIN_TF_DOCS -->

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | 3.4.0 |


## Resources

| Name | Type |
|------|------|
| [azuread_group.this](https://registry.terraform.io/providers/hashicorp/azuread/3.4.0/docs/resources/group) | resource |
| [azuread_users.users](https://registry.terraform.io/providers/hashicorp/azuread/3.4.0/docs/data-sources/users) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_assignable_to_role"></a> [assignable\_to\_role](#input\_assignable\_to\_role) | Indicates whether this group can be assigned to an Azure Active Directory role. Can only be set to true for security-enabled groups. | `bool` | `true` | no |
| <a name="input_group_name"></a> [group\_name](#input\_group\_name) | The display name for the group. | `string` | n/a | yes |
| <a name="input_owners"></a> [owners](#input\_owners) | A set of object IDs of principals that will be granted ownership of the group. Supported object types are users or service principals. | `list(string)` | <pre>[]</pre> | no |
| <a name="input_security_enabled"></a> [security\_enabled](#input\_security\_enabled) | Whether the group is a security group for controlling access to in-app resources | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_group_name"></a> [group\_name](#output\_group\_name) | Group name |
| <a name="output_group_objecti_id"></a> [group\_objecti\_id](#output\_group\_objecti\_id) | Group object ID |
<!-- END_TF_DOCS -->