data "azurerm_subscription" "current" {}

data "azuread_client_config" "current" {}

# Needed so we can assign it the 'Network Contributor' role on the created VNet
data "azuread_service_principal" "aro_resource_provisioner" {
    display_name            = "Azure Red Hat OpenShift RP"
}
 