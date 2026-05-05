variable "data" {
  description = "Naming data for the resource"
  type = object({
    resource_group_name = string
    foundry_name        = string
    project_name        = string
    subdomain_name      = optional(string, null)
  })
}

variable "location" {
  description = "The Azure region where resources will be created"
  type        = string
  default     = "west-europe"
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