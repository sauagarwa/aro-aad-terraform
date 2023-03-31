locations = {
    primary = {
        api_version = "apiextensions.k8s.io/v1"
        kind       = "CustomResourceDefinition"
        metadata_name = "testcrds.hashicorp.com"
        # spec_group    = "hashicorp.com"
        # spec_scope    = "Namespaced"
        # spec_kind     = "TestCrd"
        # spec_plural   = "testcrds"
    }
}

# apiVersion: operator.aquasec.com/v1alpha1
# kind: AquaEnforcer