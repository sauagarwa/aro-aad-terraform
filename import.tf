
locals {
  name_prefix = var.name_prefix
  cluster_name = var.cluster_name
  resource_group_name = var.resource_group_name
}
 

data "azurerm_resource_group" "resource_group" {
  name  =  local.resource_group_name
}
 

resource "azapi_resource" "aro_cluster" {
    name = local.cluster_name
    parent_id = data.azurerm_resource_group.resource_group.id
    type = "Microsoft.RedHatOpenShift/OpenShiftClusters@2022-09-04"
    location ="eastus"

    lifecycle {
    ignore_changes = [
        body,
        tags
    ]
  }
}

# locals {
#     aro_cluster = azapi_resource.aro_cluster.name
#     location = azapi_resource.aro_cluster.location
#     aro_properties = jsondecode(azapi_resource.aro_cluster.body)
#     console_url = local.aro_properties.properties.consoleProfile.url
#     apiserver_url =  local.aro_properties.properties.apiserverProfile.url
#     domain = local.aro_properties.properties.clusterProfile.domain
#     oauth_callback_url="https://oauth-openshift.apps.${local.domain}.${local.location}.aroapp.io/oauth2callback/AAD"
# }

# resource "azuread_application" "cluster" {
#     display_name            = "${local.name_prefix}-cluster-app"
#     owners                  = [data.azuread_client_config.current.object_id]
#     web {
#         redirect_uris = [local.oauth_callback_url]
#     }
    
# }

# resource "azuread_application_password" "cluster" {
#     application_object_id   = azuread_application.cluster.object_id
# }

# resource "azuread_service_principal" "cluster" {
#     application_id  = azuread_application.cluster.application_id
#     owners          = [data.azuread_client_config.current.object_id]
# }

# output "location" {
#     value =  local.location
# }

# output "console_url" {
#     value =  local.console_url
# }

# output "apiserver_url" {
#     value =  local.apiserver_url
# }

# output "domain" {
#     value =  local.domain
# }

# output "oauth_callback_url" {
#     value =  local.oauth_callback_url
# }
