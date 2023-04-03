locations = {
    primary = {
        api_version = "config.openshift.io/v1"
        kind       = "OAuth"
        metadata_name = "cluster"
        spec    = {
            identityProviders = [{
                name    = "AAD"
                mappingMethod  = "claim"
                type = "OpenID"
                openID = {
                clientID = "azuread_application.cluster.application_id}"
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
                # issuer = "https://login.microsoftonline.com/${data.azurerm_subscription.current.tenant_id}"
                }
            }]
        }
    }
}

# apiVersion: operator.aquasec.com/v1alpha1
# kind: AquaEnforcer
