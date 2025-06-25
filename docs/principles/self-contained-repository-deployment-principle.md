## Self-Contained Repository Deployment Principle

### Principle Overview
This principle asserts that any repository should be self-contained and include everything necessary to deploy itself to production.

This approach emphasizes autonomy and self-sufficiency of each code repository, irrespective of its environment.

Key components include:
- The capability to bootstrap its own pipeline.
- The capability to source newer versions of Infrastructure as Code (IAC) that describe the pipeline.
- The capability to manage an end-to-end Software Development Life Cycle (SDLC) of the code's development.
- The capability to set up immutable infrastructure or provision necessary resources for deploying the environment-agnostic artifact.
- The capability to set up and execute all scanning, linting, and unit, functional, integration, and performance testing of the artifact.
- The capability to set up telemetry collections and views for itself.

Note: The repository does not contain the input parameters or properties needed by the code artifact or the IAC by design.

### Variations of the Principle
Both variations shall be constrained by [12 Factor Principles](https://12factor.net/).

1. **Exclusive Deployment**: Everything necessary for a fully immutable deployment, excluding the hosting cloud account, is managed from within this repository, except for non-hosting dependencies on 'Shared Services' such as a cache or a queue.

2. **Shared Dependency Deployment**: All necessary components, except for a pre-existing hosting dependency upon 'Shared Services' (e.g., a Kubernetes cluster), are managed within the repository. This variation is applicable in scenarios like deploying a microservice to Kubernetes, where the Kubernetes cluster must pre-exist before any deployment can occur, or where the application service depends on services common to many applications such as a cache or queue.
