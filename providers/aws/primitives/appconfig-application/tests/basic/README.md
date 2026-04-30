# Basic Example Tests

Asserts:

- `ApplicationExists` -- the application is created with the expected name
- `EnvironmentsCreated` -- `dev` and `prod` environments exist
- `FeatureFlagsConfigurationProfileExists` -- the `feature-flags`
  profile is created with type `AWS.AppConfig.FeatureFlags` and
  location `hosted`
- `DeploymentStrategyMatchesInputs` -- duration=5, bake=5, growth=20%,
  type=LINEAR, replicate_to=NONE

## Running

```bash
make tf-test MODULE_PATH=providers/aws/primitives/appconfig-application
```
