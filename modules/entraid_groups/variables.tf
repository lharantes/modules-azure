variable "security_enabled" {
  type        = bool
  default     = true
  description = "Whether the group is a security group for controlling access to in-app resources"
}

variable "group_name" {
  type        = string
  description = "The display name for the group."
  default     = "GP-TESTE2"
}

variable "assignable_to_role" {
  type        = bool
  default     = true
  description = "Indicates whether this group can be assigned to an Azure Active Directory role. Can only be set to true for security-enabled groups."
}

variable "owners" {
  type        = list(string)
  default     = ["luiz@arantes.net.br"]
  description = "A set of object IDs of principals that will be granted ownership of the group. Supported object types are users or service principals."
}