# Basic Example Tests

Asserts:

- `OutputsPopulated` -- zone id/name and record FQDNs are populated
- `ARecordExists` -- type=A, ttl=60, two values 10.99.1.10 and 10.99.1.11
- `CNAMERecordExists` -- type=CNAME, points at the A record's FQDN

## Running

```bash
make tf-test MODULE_PATH=providers/aws/primitives/route53-record
```
