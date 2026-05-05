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
    project = "myproject"
    type    = "foundry"
  }

  environment = "d"
  location    = "west-europe"

  subdomain_name      = "my-foundry-subdomain"
  resource_group_name = "rg-myproject"

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
| `data` | Naming data for the resource (`client`, `project`, `type`) | `object` | — | yes |
| `role` | Role suffix appended to the resource name | `string` | `null` | no |
| `environment` | Environment tag — one of `d`, `s`, `t`, `p` | `string` | — | yes |
| `location` | Azure region | `string` | `"west-europe"` | no |
| `subdomain_name` | Custom subdomain for the AI Foundry endpoint | `string` | `null` | no |
| `resource_group_name` | Target resource group name | `string` | `null` | no |
| `foundry_params` | SKU and tags for the cognitive account | `object` | `{ sku = "F0", tags = {} }` | no |
| `deployments` | Map of model deployments (SKU + model definition) | `map(object)` | `{ "gpt-4o" = ... }` | no |

## Locals

| Name | Description |
|---|---|
| `resource_group_name` | Uses `var.resource_group_name` if provided, otherwise falls back to the naming module default |
| `subdomain_name` | Uses `var.subdomain_name` if provided, otherwise defaults to `aifoundry<naming>` |

## Example — `dev.tfvars`

```hcl
data = {
  project = "project"
  type    = "foundry"
}

location    = "west-europe"
environment = "d"

subdomain_name = "my-foundry-subdomain"

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
