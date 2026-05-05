locals {
  resource_group_name = (var.resource_group_name != null && length(var.resource_group_name) > 0 ? var.resource_group_name : module.naming.resource_group)
  subdomain_name      = (var.subdomain_name != null && length(var.subdomain_name) > 0 ? var.subdomain_name : "aifoundry${module.naming.name}")
}