module "naming" {
  source = "git@github.com:h0livier/terraform-naming-helper.git?ref=main"

  data = {
    client  = var.data.client
    project = var.data.project
    type    = var.data.type
  }

  role        = var.role
  environment = var.environment
}

## Create an AI Foundry resource
resource "azurerm_cognitive_account" "ai_foundry" {
  name                = "aifoundry${module.naming.name}"
  location            = var.location
  resource_group_name = local.resource_group_name
  kind                = "AIServices"

  identity {
    type = "SystemAssigned"
  }

  sku_name = "F0"

  # required for stateful development in Foundry including agent service
  custom_subdomain_name      = local.subdomain_name
  project_management_enabled = true

  tags = {
    Acceptance = "Test"
  }
}

# Create a Foundry project (folder for organizing stateful work)
resource "azurerm_cognitive_account_project" "ai_project" {
  name                 = module.naming.name
  cognitive_account_id = azurerm_cognitive_account.ai_foundry.id
  location             = var.location

  identity {
    type = "SystemAssigned"
  }
}

## Create deployments in the AI Foundry resource
resource "azurerm_cognitive_deployment" "aifoundry_deployments" {
  for_each = var.deployments

  name                 = each.key
  cognitive_account_id = azurerm_cognitive_account.ai_foundry.id

  sku {
    name     = each.value.sku.name
    tier     = each.value.sku.tier
    capacity = each.value.sku.capacity
  }

  model {
    format  = each.value.model.format
    name    = each.value.model.name
    version = each.value.model.version
  }
}