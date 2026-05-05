variable "data" {
  description = "Naming data for the resource"
  type = object({
    client  = optional(string, "null")
    project = string
    type    = string
  })
}

variable "role" {
  description = "The role of the resource"
  type        = string
  default     = null
}

variable "location" {
  description = "The Azure region where resources will be created"
  type        = string
  default     = "west-europe"
}

variable "environment" {
  description = "The environment of the project (e.g., d, s, t, p)"
  type        = string

  validation {
    condition     = contains(["d", "s", "t", "p"], var.environment)
    error_message = "Environment must be one of: d, s, t, p"
  }
}

variable "subdomain_name" {
  description = "The Subdomain name for the AI Foundry resource"
  type        = string
  default     = null
}

variable "resource_group_name" {
  description = "The name of the resource group for the AI Foundry resource"
  type        = string
  default     = null
}

variable "foundry_params" {
  description = "Additional parameters for AI Foundry resource creation"
  type = object({
    sku  = string
    tags = map(string)
  })
  default = {
    sku  = "F0"
    tags = {}
  }
}

variable "deployments" {
  description = "Deployments to create in the AI Foundry account"
  type = map(object({
    sku = object({
      name     = string
      tier     = string
      capacity = number
    })
    model = object({
      format  = string
      name    = string
      version = string
    })
  }))
  default = {
    "gpt-4o" = {
      sku = {
        name     = "GlobalStandard"
        tier     = "Free"
        capacity = 1
      },
      model = {
        format  = "OpenAI"
        name    = "gpt-4o"
        version = "2024-11-20"
      }
    }
  }
}