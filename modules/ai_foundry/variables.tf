variable "environment" {
  type        = string
  description = "Environment project (dev, qua or prd)."
}

variable "service_prefix" {
  type        = string
  description = "Prefix or name of the project."
}

variable "location" {
  type        = string
  description = "Specifies the supported Azure location where the resource exists."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the Resource Group where the AI Foundry Hub should exist. Changing this forces a new AI Foundry Hub to be created."
}

variable "key_vault_id" {
  type        = string
  description = "The Key Vault ID that should be used by this AI Foundry Hub. Changing this forces a new AI Foundry Hub to be created."
}

variable "storage_account_id" {
  type        = string
  description = "The Storage Account ID that should be used by this AI Foundry Hub. Changing this forces a new AI Foundry Hub to be created."
}

variable "identity" {
  type = object({
    type         = string
    identity_ids = optional(list(string), [])
  })
  default = {
    type = "SystemAssigned"
  }
  description = "A identity and possibles values are SystemAssigned, UserAssigned, and SystemAssigned, UserAssigned."

  validation {
    condition     = contains(["SystemAssigned", "UserAssigned", "SystemAssigned, UserAssigned"], var.identity.type)
    error_message = "Possible values are SystemAssigned, UserAssigned, and SystemAssigned, UserAssigned."
  }
}

### Optional Variables

variable "public_network_access" {
  type        = string
  default     = "Disabled"
  description = "Whether public network access for this AI Service Hub should be enabled."

  validation {
    condition     = contains(["Disabled", "Enabled"], var.public_network_access)
    error_message = "Possible values include Enabled and Disabled."
  }
}

variable "application_insights_id" {
  type        = string
  description = "There is a Application Insights ID that should be used by this AI Foundry Hub."
  default     = ""
}

variable "friendly_name" {
  type        = string
  description = "The display name of this AI Foundry Hub."
  default     = ""
}

variable "managed_network" {
  type        = string
  default     = "Disabled"
  description = "Different configuration modes for outbound traffic from the managed virtual network."

  validation {
    condition     = contains(["Disabled", "AllowOnlyApprovedOutbound", "AllowInternetOutbound"], var.managed_network)
    error_message = "Possible values are Disabled, AllowOnlyApprovedOutbound, AllowInternetOutbound."
  }
}

variable "enable_private_endpoint" {
  type        = bool
  default     = true
  description = "Enabled private endpoint connection."
}

variable "dns_resource_group_name" {
  type        = string
  default     = ""
  description = "Private dns for the private endpoint."
}

variable "subnet_id" {
  type        = string
  default     = ""
  description = "Subnet ID for the private endpoint."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Optional tags to add to resources."
}