#!/bin/bash

# Script to run a single test with timeout and debug logging
set -e

# Clean up any existing state
echo "Cleaning up existing state..."
make clean

# Clean Go test cache
echo "Cleaning Go test cache..."
go clean -cache -testcache

# Remove terraform lock files to allow fresh provider resolution
echo "Removing terraform lock files..."
find . -name ".terraform.lock.hcl" -delete || true
find . -name ".terraform" -type d -exec rm -rf {} + || true

# Set environment variables for debugging
export TF_LOG=DEBUG
export TF_LOG_PATH=/tmp/terraform-debug.log
export TERRATEST_IDEMPOTENCY=false

# Run the specific failing test with timeout
echo "Running TestAllAssertionTypes/basic test with 5-minute timeout..."
cd tests/basic
timeout 300s go test -v -run "TestAllAssertionTypes/basic" -count=1 || {
    echo "Test timed out or failed"
    echo "Terraform debug log:"
    if [ -f /tmp/terraform-debug.log ]; then
        tail -50 /tmp/terraform-debug.log
    fi
    exit 1
}

echo "Test completed successfully"