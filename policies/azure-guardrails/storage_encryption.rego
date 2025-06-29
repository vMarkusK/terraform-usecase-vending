# METADATA
# title: Storage Account Guardrails Encryption
# description: Enforces recommended encryption guardrails for Storage Account
# custom:
#   id: AZ-GR-ST-001
#   severity: HIGH
#   input:
#     selector:
#       - type: terraform

package azure.guardrails.storage_encryption

deny[res] {
    input.resource_type == "azurerm_storage_account"
    not secure_transfer_enabled(input.values)
    msg := sprintf("Storage account '%s' must have secure transfer enabled", [input.values.name])
    res := {
        "msg": msg,
        "filepath": input.filepath,
        "startline": input.start_line,
        "endline": input.end_line
    }
}

deny[res] {
    input.resource_type == "azurerm_storage_account"
    not minimum_tls_version_set(input.values)
    msg := sprintf("Storage account '%s' must have minimum TLS version 1.2", [input.values.name])
    res := {
        "msg": msg,
        "filepath": input.filepath,
        "startline": input.start_line,
        "endline": input.end_line
    }
}

secure_transfer_enabled(values) {
    values.enable_https_traffic_only == true
}

minimum_tls_version_set(values) {
    values.min_tls_version == "TLS1_2"
}
