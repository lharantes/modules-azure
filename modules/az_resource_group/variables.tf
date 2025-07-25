variable "location" {
  type        = string
  description = "Azure region where the resource should be deployed."
  nullable    = false
  default     = "North Europe"
}

variable "service_prefix" {
  type        = string
  description = "A short name that indicates the purpose of the service."
  nullable    = false
}

variable "environment" {
  type        = string
  description = "A short name that indicates the environment (prd, dev, qua)."
  nullable    = false

  validation {
    condition     = alltrue([contains(["prd", "dev", "qua"], var.environment)])
    error_message = "Environment name must have one of: 'prd', 'dev', 'qua'."
  }
}

# variable "subscription_id" {}
#variable "tenant_id" {}
