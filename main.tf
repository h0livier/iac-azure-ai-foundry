## Create an AI Foundry resource
resource "azurerm_cognitive_account" "ai_foundry" {
  name                = "aifoundry${var.data.foundry_name}"
  location            = var.location
  resource_group_name = var.data.resource_group_name
  kind                = "AIServices"

  identity {
    type = "SystemAssigned"
  }

  sku_name = "F0"

  # required for stateful development in Foundry including agent service
  custom_subdomain_name      = var.data.subdomain_name
  project_management_enabled = true

  tags = {
    Acceptance = "Test"
  }
}

# Create a Foundry project (folder for organizing stateful work)
resource "azurerm_cognitive_account_project" "ai_project" {
  name                 = var.data.project_name
  cognitive_account_id = azurerm_cognitive_account.ai_foundry.id
  location             = var.location

  identity {
    type = "SystemAssigned"
  }
}

## Create deployments in the AI Foundry resource
resource "azurerm_cognitive_deployment" "aifoundry_deployments" {
  for_each   = var.deployments
  depends_on = [azurerm_cognitive_account.ai_foundry]

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