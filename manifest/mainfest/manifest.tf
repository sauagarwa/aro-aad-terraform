provider "kubernetes" {
    config_path = "./kubeconfig"
}

variable "locations" {
  type = any
  default = {}
}

module "kubernetes_manifest" {
  source = "../"
  for_each = var.locations
  api_version     = each.value.api_version
  kind            = each.value.kind #"CustomResourceDefinition"
  metadata_name   = each.value.metadata_name #"testcrds.hashicorp.com"
  spec            = lookup(each.value, "spec", {}) #"hashicorp.com"
  spec_scope      = lookup(each.value, "spec_scope", null) #"Namespaced"
  spec_kind       = lookup(each.value, "spec_kind", null) #"TestCrd"
  spec_plural     = lookup(each.value, "spec_plural", null) #"testcrds"
}

# resource "kubernetes_manifest" "test-crd" {
#   manifest = {
#     apiVersion = "config.openshift.io/v1"
#     kind       = "OAuth"

#     metadata = {
#       name = "cluster"
#     }

#     spec = {
#       identityProviders = [{
#         name    = "AAD"
#         mappingMethod  = "claim"
#         type = "OpenID"
#         openID = {
#           clientID = "azuread_application.cluster.application_id}"
#           clientSecret = {
#             name = "openid-client-secret-azuread"
#           }
#           extraScopes = [
#             "email",
#             "profile"
#           ]
#           extraAuthorizeParameters = {
#             include_granted_scopes = "true"
#           }
#           claims = {
#             preferredUsername = [
#                 "email",
#                 "upn"
#             ]
#             name = [
#                 "name"
#             ]
#             email = [
#                 "email"
#             ]

#           }
#           # issuer = "https://login.microsoftonline.com/${data.azurerm_subscription.current.tenant_id}"
#         }
#       }]
#     }
#   }
# }