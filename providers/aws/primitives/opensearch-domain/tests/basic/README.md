# Basic Example Tests

Asserts:

- `DomainExists` -- ARN, name, endpoint, and log group ARN are populated
- `DomainHasEncryptionAndHttps` -- `EncryptionAtRestOptions.Enabled`, `NodeToNodeEncryptionOptions.Enabled`, `DomainEndpointOptions.EnforceHTTPS` are all true; TLS policy = `Policy-Min-TLS-1-2-PFS-2023-10`
- `ApplicationLoggingEnabled` -- `ES_APPLICATION_LOGS` publishing is enabled and points at the auto-created log group

## Running

```bash
make tf-test MODULE_PATH=providers/aws/primitives/opensearch-domain
```
