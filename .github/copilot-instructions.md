- @azure Rule - Use Azure Best Practices: When generating code for Azure, running terminal commands for Azure, or performing operations related to Azure, invoke your `azure_development-get_best_practices` tool if available.

- @terraform Rule - Code Style:
  - Follow the [Terraform Style Guide](https://developer.hashicorp.com/terraform/language/style).
  - Follow standard Terraform file structure (main.tf, variables.tf, outputs.tf)
  - Use 2 spaces for indentation, never tabs.
  - Use snake_case for resource, variable, and output names.
  - Use lowercase for all resource types and names.
  - Group related blocks together and order them: provider, data, resource, output, variable, locals.
  - Add a blank line between top-level blocks.
  - Use descriptive names for resources and variables.
  - Use double quotes for all strings.
  - Align `=` signs within blocks for readability.
  - Add comments to explain complex logic or non-obvious configurations.
  - Prefer explicit over implicit dependencies.
  - Avoid hardcoding values; use variables or locals where appropriate.
  - Keep resource blocks concise; split large files into logical modules.
  - Use consistent naming conventions throughout the codebase.
  - Remove unused variables, outputs, and resources.

- @terraform Rule - Azure Security Best Practices:
  - Use Azure Managed Identities for authentication where possible
  - Use Azure Key Vault for secret management
  - Implement least privilege access for service principals
  - Use data encryption at rest and in transit

- @terraform Rule - Azure Resource Management:
  - Enable soft delete for applicable resources
  - Implement proper backup and disaster recovery
  - Use resource locks for critical resources
  - Implement proper monitoring and logging

- @azure Rule - Compliance:
  - Follow Azure landing zone principles
  - Implement proper resource organization (Management Groups, Subscriptions, Resource Groups)
  - Enable Azure Policy for governance
  - Use Azure Monitor for monitoring and alerting
  - Implement proper RBAC (Role-Based Access Control)
