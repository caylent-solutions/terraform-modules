# appconfig-application / basic example

Creates an AppConfig application with `dev` and `prod` environments, a
feature-flags configuration profile, and a 5-step LINEAR/5-minute
deployment strategy.

## What it creates

- `module.appconfig` -- the `appconfig-application` primitive
- `dev` and `prod` environments
- One configuration profile (`feature-flags`, type `AWS.AppConfig.FeatureFlags`, location `hosted`)
- A deployment strategy with `duration=5min, growth=20%, growth_type=LINEAR, bake=5min`

## Apply

```bash
cd providers/aws/primitives/appconfig-application/examples/basic
terraform init
terraform apply -auto-approve
```

See [TERRAFORM-DOCS.md](TERRAFORM-DOCS.md).
