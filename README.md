# iac-azure-ai-foundry

Terraform module to deploy an **Azure AI Foundry** resource (`AIServices` cognitive account), a Foundry project, and one or more model deployments.

## Resources created

| Resource | Type |
|---|---|
| AI Foundry account | `azurerm_cognitive_account` |
| AI Foundry project | `azurerm_cognitive_account_project` |
| Model deployments | `azurerm_cognitive_deployment` |

## Requirements

| Name | Version |
|---|---|
| Terraform | `>= 1.14.0` |
| `hashicorp/azurerm` | `>= 4.71.0` |

## Usage

```hcl
module "ai_foundry" {
  source = "git@github.com:<org>/iac-azure-ai-foundry.git?ref=main"

  data = {
    resource_group_name = "rg-myproject"
    foundry_name        = "myfoundry"
    project_name        = "myproject"
    subdomain_name      = "my-foundry-subdomain"
  }

  location = "west-europe"

  foundry_params = {
    sku  = "F0"
    tags = { Environment = "dev" }
  }

  deployments = {
    "gpt-4o" = {
      sku = {
        name     = "GlobalStandard"
        tier     = "Free"
        capacity = 1
      }
      model = {
        format  = "OpenAI"
        name    = "gpt-4o"
        version = "2024-11-20"
      }
    }
  }
}
```

## Variables

| Name | Description | Type | Default | Required |
|---|---|---|---|---|
| `data.resource_group_name` | Name of the target resource group | `string` | — | yes |
| `data.foundry_name` | Suffix used to name the AI Foundry account (`aifoundry<foundry_name>`) | `string` | — | yes |
| `data.project_name` | Name of the Foundry project | `string` | — | yes |
| `data.subdomain_name` | Custom subdomain for the AI Foundry endpoint | `string` | `null` | no |
| `location` | Azure region | `string` | `"west-europe"` | no |
| `foundry_params` | SKU and tags for the cognitive account | `object({ sku = string, tags = map(string) })` | `{ sku = "F0", tags = {} }` | no |
| `deployments` | Map of model deployments (SKU + model definition) | `map(object)` | `{ "gpt-4o" = ... }` | no |

## Example — `dev.tfvars`

```hcl
data = {
  resource_group_name = "rg-myproject"
  foundry_name        = "myproject"
  project_name        = "myproject"
  subdomain_name      = "my-foundry-subdomain"
}

location = "west-europe"

deployments = {
  "gpt-4o" = {
    sku = {
      name     = "GlobalStandard"
      tier     = "Free"
      capacity = 1
    }
    model = {
      format  = "OpenAI"
      name    = "gpt-4o"
      version = "2024-11-20"
    }
  }
}
```

Apply with:

```bash
terraform init
terraform apply -var-file="dev.tfvars"
```
