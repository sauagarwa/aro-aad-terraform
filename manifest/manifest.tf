# # resource "null_resource" "azlogin" {
# #     provisioner "local-exec" {
# #         command = <<-EOT
# #         az aro get-admin-kubeconfig -g ARO-EUS-RG -n ar-aroAro
# #         EOT
# #     }
# #     # depends_on = [
# #     #   azapi_resource.aro_cluster
# #     # ]
# # }

# provider "kubernetes" {
#     config_path = "./kubeconfig"
# }

resource "kubernetes_manifest" "manifest" {
    manifest = {
        apiVersion = var.api_version
        kind       = var.kind

        metadata = {
            name = var.metadata_name
        }

        spec = var.spec
        # {
        #     group = var.spec_group #"hashicorp.com"
        #     scope = var.spec_scope #"Namespaced"

        #     names = {
        #         kind   = var.spec_kind #"TestCrd"
        #         plural = var.spec_plural #"testcrds"
        #     }

        #     versions = [{
        #         name    = "v1"
        #         served  = true
        #         storage = true
        #         # schema = {
        #         # }
        #     }]
        # }
    }
}

#   dynamic "manifest" {
#         for_each = length(var.manifest) > 0 ? [var.manifest] : {}
#         content {
#             apiVersion = lookup(manifest.value, "apiVersion", null) #var.manifest.apiVersion #
#             kind = lookup(manifest.value, "kind", null) #var.manifest.kind #
#             # apiVersion = "apiextensions.k8s.io/v1"
#             # kind       = "CustomResourceDefinition"

#             dynamic "metadata" {
#                 for_each = lookup(manifest.value, "metadata", {})
#                 content {
#                     name = "testcrds.hashicorp.com" #lookup(metadata, "frequency_interval", [])
#                 }
#             }
#             dynamic "spec" {
#                 for_each = lookup(manifest.value, "spec", {})
#                 content {
#                     scope   = lookup(spec.value, "scope", null)
#                     group       = lookup(spec, "group", [])

#                     dynamic "names" {
#                         for_each = lookup(spec.value, "names", {})
#                         content {
#                             kind       = lookup(names, "kind", [])
#                             plural     = lookup(names, "plural", [])
#                         }
#                     }
#                     dynamic "versions" {
#                         for_each = lookup(spec.value, "versions", [])
#                         content {
#                             name       = lookup(versions, "name", [])
#                             served     = lookup(versions, "served", [])
#                             storage    = lookup(versions, "storage", [])
#                             schema = { 
#                                 openAPIV3Schema = {
#                                     type = "object"
#                                     properties = {
#                                         data = {
#                                             type = "string"
#                                         }
#                                         refs = {
#                                             type = "number"
#                                         }
#                                     }
#                                 }
#                             }
#                         }
#                     }
#                 }
#             }
#         }
#     }
# }