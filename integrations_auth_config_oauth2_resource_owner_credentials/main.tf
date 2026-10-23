resource "google_integrations_auth_config" "oauth2_resource_owner_credentials_example" {
    location = "us-east4"
    display_name = "test-authconfig-oauth2-resource-owner-credentials-${local.name_suffix}"
    description = "Test auth config created via terraform"
    decrypted_credential {
        credential_type = "OAUTH2_RESOURCE_OWNER_CREDENTIALS"
        oauth2_resource_owner_credentials {
            client_id = "demo-backend-client"
            client_secret = "MJlO3binatD9jk1"
            username = "test-username"
            password = "test-password"
            scope = "read"
            token_endpoint = "https://oauth.wiremockapi.cloud/oauth/token"
            request_type = "ENCODED_HEADER"
            token_params {
                entries {
                    key {
                        literal_value {
                            string_value = "code"
                        }
                    }
                    value {
                        literal_value {
                            string_value = "YS4uYi4uYy4uZGVm"
                        }
                    }
                }
            }
        }
    }
}
