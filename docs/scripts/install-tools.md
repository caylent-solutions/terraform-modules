# Install Tools Script

This document describes the script used to install and manage development tools for the Terraform modules monorepo.

## Overview

The `install-tools` script automates the installation and management of development tools using [ASDF](https://asdf-vm.com/), a version manager that supports multiple runtime versions. It ensures all developers use consistent tool versions as defined in the `.tool-versions` file.

## Features

- Installs ASDF version manager if not already installed
- Installs all tools defined in the `.tool-versions` file
- Updates existing tools to ensure they match the required versions
- Supports running in development containers
- Enforces maximum allowed ASDF version for compatibility

## Usage

The script is primarily used through the following make tasks:

```bash
# Install all required development tools
make install-tools

# Update existing tools to the versions specified in .tool-versions
make update-tools
```

## Command Line Options

- `--update`: Only update existing tools, don't perform a full installation
- `--asdf-version=<version>`: Specify the ASDF version to install (defaults to v0.15.0)

## Configuration

The script uses the `.tool-versions` file in the repository root to determine which tools and versions to install. This file follows the standard ASDF format:

```
# Example .tool-versions file
terraform 1.5.7
golang 1.21.3
opa 0.58.0
```

## Behavior

### First-time Installation

When run for the first time, the script:

1. Checks if ASDF is already installed
2. If not, installs ASDF at the specified version (default: v0.15.0)
3. Adds all plugins specified in the `.tool-versions` file
4. Installs all tools at the versions specified in the `.tool-versions` file
5. Runs `asdf reshim` to ensure all tools are properly linked

### Update Mode

When run with the `--update` flag, the script:

1. Verifies that ASDF is installed
2. Ensures all required plugins are installed
3. Updates all tools to the versions specified in the `.tool-versions` file
4. Runs `asdf reshim` to ensure all tools are properly linked

### Development Container Support

The script detects if it's running in a development container by checking the `DEVCONTAINER` environment variable. If detected, it assumes tools are already installed and only runs the update process.

## Error Handling

The script exits with a non-zero status code in the following cases:

1. The `.tool-versions` file cannot be read
2. ASDF installation fails
3. Plugin installation fails
4. Tool installation fails
5. Reshimming fails

Error messages clearly explain what went wrong and provide guidance on how to resolve the issue.

## Implementation Details

The script is implemented in Go and follows these steps:

1. Parse command line arguments
2. Check if running in update mode or in a development container
3. Install ASDF if needed
4. Parse the `.tool-versions` file
5. Install or update plugins and tools
6. Reshim to ensure all tools are properly linked

## Version Management

The script enforces a maximum allowed ASDF version (v0.15.0) to ensure compatibility. If a higher version is requested, it will use the maximum allowed version instead and display a warning message.