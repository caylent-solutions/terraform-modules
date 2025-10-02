#!/usr/bin/env bash

# Project-specific setup script
# This script runs after the main devcontainer setup is complete
# Add your project-specific initialization commands here
#
# Examples:
# - make configure
# - npm install
# - pip install -r requirements.txt
# - docker-compose up -d
# - Initialize databases
# - Download project dependencies
# - Run project-specific configuration

set -euo pipefail

# Source shared functions
source "$(dirname "$0")/devcontainer-functions.sh"

log_info "Running project-specific setup..."

make configure

log_info "Add project specific setup commands here!"

log_info "Project-specific setup complete"
