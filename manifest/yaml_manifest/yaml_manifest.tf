provider "kubernetes" {
    config_path = "./kubeconfig"
}

# locals {
#     raw_manifests = split("\n---", file("./nginx.yaml"))
#     hcl_manifests = [for manifest in local.raw_manifests : yamldecode(manifest)]
# }

# resource "kubernetes_manifest" "manifest" {
#     count = length(local.hcl_manifests)
#     manifest = local.hcl_manifests[count.index]
# }

resource "kubernetes_manifest" "example_km" {
  manifest = yamldecode(<<-EOF
        apiVersion: operator.aquasec.com/v1alpha1
        kind: AquaEnforcer
        metadata:
        name: aqua
        spec:
        infra:
            serviceAccount: aqua-sa
            version: '2022.4'
        common:
            imagePullSecret: aqua-registry
        deploy:
            image:
            repository: enforcer
            registry: registry.aquasec.com
            tag: <<IMAGE TAG>>
            pullPolicy: IfNotPresent
        runAsNonRoot: false
        gateway:
            host: aqua-gateway
            port: 8443
        token: <<your-token>>
    EOF
  )
}