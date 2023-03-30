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

resource "azapi_resource_action" "listAdminCredentials" {
  type                   = "Microsoft.RedHatOpenShift/OpenShiftClusters@2021-09-01-preview"
  resource_id            =  azapi_resource.aro_cluster.id
  action                 = "listAdminCredentials"
  response_export_values = ["*"]
}

resource "azapi_resource_action" "listCredentials" {
  type                   = "Microsoft.RedHatOpenShift/OpenShiftClusters@2022-04-01"
  resource_id            =  azapi_resource.aro_cluster.id
  action                 = "listCredentials"
  response_export_values = ["*"]
  depends_on = [
        local_file.kubeconfig
    ]
}

locals {
    aro_cluster = azapi_resource.aro_cluster.name
    location = azapi_resource.aro_cluster.location
    aro_properties = jsondecode(azapi_resource.aro_cluster.body)
    console_url = local.aro_properties.properties.consoleProfile.url
    apiserver_url =  local.aro_properties.properties.apiserverProfile.url
    domain = local.aro_properties.properties.clusterProfile.domain
    oauth_callback_url="https://oauth-openshift.apps.${local.domain}.${local.location}.aroapp.io/oauth2callback/AAD"
    aro_credentials = jsondecode(azapi_resource_action.listCredentials.output)
    kube_admin_username = local.aro_credentials.kubeadminUsername
    kube_admin_password = local.aro_credentials.kubeadminPassword
    admin_credentials = jsondecode(azapi_resource_action.listAdminCredentials.output)
    kube_config = base64decode(local.admin_credentials.kubeconfig)
}

resource "local_file" "kubeconfig" {
    filename = "${path.module}/kubeconfig"
    content = local.kube_config
    depends_on = [
        azapi_resource_action.listAdminCredentials
    ]
}


resource "azuread_application" "cluster" {
    display_name            = "${local.name_prefix}-cluster-app"
    owners                  = [data.azuread_client_config.current.object_id]
    web {
        redirect_uris = [local.oauth_callback_url]
    }

    optional_claims {
        id_token {
            name                  = "upn"
            source                = null
            essential             = false
            additional_properties = []
        }

        id_token {
            name                  = "email"
            source                = null
            essential             = false
            additional_properties = []
        }
    }

    required_resource_access {
        resource_app_id = "00000002-0000-0000-c000-000000000000"  # MS Graph app id.

        resource_access {
            id   = "311a71cc-e848-46a1-bdf8-97ff7156d8e6" # User.Read.All id.
            type = "Scope"
        }
    }
}


resource "azuread_application_password" "cluster" {
    application_object_id   = azuread_application.cluster.object_id
}

resource "azuread_service_principal" "cluster" {
    application_id  = azuread_application.cluster.application_id
    owners          = [data.azuread_client_config.current.object_id]
}

output "location" {
    value =  local.location
}

output "console_url" {
    value =  local.console_url
}

output "apiserver_url" {
    value =  local.apiserver_url
}

output "domain" {
    value =  local.domain
}

output "oauth_callback_url" {
    value =  local.oauth_callback_url
}

output "tenant_id" {
    value =  data.azurerm_subscription.current.tenant_id
}

output "parent_id" {
    value = azapi_resource.aro_cluster.id
}

output "kube_admin_username" {
    value = local.kube_admin_username
}

output "kube_admin_password" {
    value = local.kube_admin_password
}

output "admin_credentials" {
    value =  azapi_resource_action.listAdminCredentials
}

output "kube_config" {
    value =  local.kube_config
}

output "kube_config_path" {
    value = path.module
}


