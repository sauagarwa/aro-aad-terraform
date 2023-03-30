
# locals {
#   host                   = "${data.azurerm_kubernetes_cluster.example.kube_config.0.host}"
#   client_certificate     = "${base64decode(data.azurerm_kubernetes_cluster.example.kube_config.0.client_certificate)}"
#   client_key             = "${base64decode(data.azurerm_kubernetes_cluster.example.kube_config.0.client_key)}"
#   cluster_ca_certificate = "${base64decode(data.azurerm_kubernetes_cluster.example.kube_config.0.cluster_ca_certificate)}"
    
# }

# locals {
#     token = "${yamldecode(var.kube_config)["users"][0]["user"]["token"]}"
#     host = "${yamldecode(var.kube_config)["clusters"][0]["cluster"]["server"]}"

# }

provider "kubernetes" {
   config_path = "${local_file.kubeconfig.filename}"

#   username     = local.kube_admin_username
#   password             = local.kube_admin_password
    insecure = true
    # host = local.apiserver_url
}

resource "kubernetes_secret_v1" "openid-client-secret-azuread" {
  metadata {
    name = "openid-client-secret-azuread"
    namespace = "openshift-config"
  }

  data = {
    clientSecret = azuread_application_password.cluster.value
  }

  type = "Opaque"
}

resource "kubernetes_manifest" "oidc" {
  manifest = {
    apiVersion = "config.openshift.io/v1"
    kind       = "OAuth"

    metadata = {
      name = "cluster"
    }

    spec = {
      identityProviders = [{
        name    = "AAD"
        mappingMethod  = "claim"
        type = "OpenID"
        openID = {
          clientID = "${azuread_application.cluster.application_id}"
          clientSecret = {
            name = "openid-client-secret-azuread"
          }
          extraScopes = [
            "email",
            "profile"
          ]
          extraAuthorizeParameters = {
            include_granted_scopes = "true"
          }
          claims = {
            preferredUsername = [
                "email",
                "upn"
            ]
            name = [
                "name"
            ]
            email = [
                "email"
            ]

          }
          issuer = "https://login.microsoftonline.com/${data.azurerm_subscription.current.tenant_id}"
        }
      }]
    }
  }
  depends_on = [
     azapi_resource_action.listAdminCredentials
  ]
}
