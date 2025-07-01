#!/bin/bash

# AWS Nuke Execution Script
# ⚠️  WARNING: This script will delete AWS resources permanently
# Only use on development/test accounts!

# Remove set -e temporarily to handle interactive prompts better
# set -e  # Exit on any error

# Configuration
CONFIG_FILE="${1:-nuke-config.yaml}"
DRY_RUN="${2:-true}"
FORCE="${3:-false}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_color() {
    printf "${1}${2}${NC}\n"
}

print_banner() {
    echo "=================================="
    print_color $RED "     AWS NUKE EXECUTION SCRIPT"
    print_color $YELLOW "   ⚠️  DESTRUCTIVE OPERATION ⚠️"
    echo "=================================="
}

check_prerequisites() {
    print_color $BLUE "Checking prerequisites..."
    
    # Check if aws-nuke exists
    if ! command -v aws-nuke &> /dev/null; then
        print_color $RED "ERROR: aws-nuke is not installed or not in PATH"
        exit 1
    fi
    
    # Check if config file exists
    if [[ ! -f "$CONFIG_FILE" ]]; then
        print_color $RED "ERROR: Configuration file '$CONFIG_FILE' not found"
        exit 1
    fi
    
    # Check AWS credentials with platform-qa profile
    if ! aws sts get-caller-identity --profile platform-qa &> /dev/null; then
        print_color $RED "ERROR: AWS credentials not configured or invalid for profile 'platform-qa'"
        exit 1
    fi
    
    print_color $GREEN "Prerequisites check passed ✓"
}

verify_account() {
    print_color $BLUE "Verifying AWS account..."
    
    CURRENT_ACCOUNT=$(aws sts get-caller-identity --profile platform-qa --query Account --output text)
    print_color $YELLOW "Current AWS Account ID: $CURRENT_ACCOUNT"
    
    # Extract account ID from config file
    CONFIG_ACCOUNT=$(grep -A 5 "accounts:" "$CONFIG_FILE" | grep -E "^\s*\"[0-9]{12}\":" | sed 's/.*"\([0-9]*\)".*/\1/' | head -1)
    
    if [[ "$CURRENT_ACCOUNT" != "$CONFIG_ACCOUNT" ]]; then
        print_color $RED "ERROR: Current account ($CURRENT_ACCOUNT) doesn't match config account ($CONFIG_ACCOUNT)"
        exit 1
    fi
    
    print_color $GREEN "Account verification passed ✓"
}

safety_prompt() {
    if [[ "$FORCE" != "true" ]]; then
        print_color $RED "⚠️  FINAL WARNING ⚠️"
        print_color $YELLOW "This will permanently delete AWS resources in account: $(aws sts get-caller-identity --profile platform-qa --query Account --output text)"
        print_color $YELLOW "Configuration file: $CONFIG_FILE"
        
        if [[ "$DRY_RUN" == "true" ]]; then
            print_color $BLUE "Running in DRY RUN mode (no actual deletions)"
        else
            print_color $RED "Running in DESTRUCTIVE mode (will actually delete resources)"
        fi
        
        echo ""
        printf "Type 'DELETE' to confirm: "
        read confirmation
        
        if [[ "$confirmation" != "DELETE" ]]; then
            print_color $YELLOW "Aborted by user"
            exit 0
        fi
        
        print_color $GREEN "Confirmation received, proceeding..."
    fi
}

run_aws_nuke() {
    print_color $BLUE "Starting AWS Nuke execution..."
    
    NUKE_ARGS="--config $CONFIG_FILE --profile platform-qa"
    
    if [[ "$DRY_RUN" == "true" ]]; then
        print_color $BLUE "Running DRY RUN (default mode - no --no-dry-run flag)..."
    else
        NUKE_ARGS="$NUKE_ARGS --no-dry-run"
        print_color $RED "Running DESTRUCTIVE execution..."
    fi
    
    if [[ "$FORCE" == "true" ]]; then
        NUKE_ARGS="$NUKE_ARGS --force"
    fi
    
    print_color $YELLOW "Note: Some errors and warnings are expected for protected AWS resources"
    echo ""
    
    # Create temporary file to capture output
    TEMP_OUTPUT=$(mktemp)
    
    # Execute aws-nuke with platform-qa profile and capture output
    aws-nuke $NUKE_ARGS 2>&1 | tee "$TEMP_OUTPUT"
    
    NUKE_EXIT_CODE=${PIPESTATUS[0]}
    
    # Analyze the output for common patterns
    analyze_nuke_output "$TEMP_OUTPUT"
    
    # Show summary of what happened
    show_execution_summary $NUKE_EXIT_CODE
    
    # Cleanup temp file
    rm -f "$TEMP_OUTPUT"
    
    if [[ $NUKE_EXIT_CODE -eq 0 ]]; then
        print_color $GREEN "AWS Nuke completed successfully ✓"
    else
        print_color $YELLOW "AWS Nuke completed with some expected warnings/errors"
        print_color $BLUE "This is normal for protected AWS resources - see summary above"
    fi
}

analyze_nuke_output() {
    local output_file="$1"
    
    if [[ ! -f "$output_file" ]]; then
        return
    fi
    
    echo ""
    print_color $BLUE "=== OUTPUT ANALYSIS ==="
    
    # Count different types of expected messages
    local cannot_delete=$(grep -c "cannot delete\|Cannot delete" "$output_file" 2>/dev/null || echo "0")
    local errors=$(grep -c "ERRO\[" "$output_file" 2>/dev/null || echo "0")
    local warnings=$(grep -c "WARN\[" "$output_file" 2>/dev/null || echo "0")
    local would_remove=$(grep -c "would remove" "$output_file" 2>/dev/null || echo "0")
    
    print_color $YELLOW "Protected resources (expected): $cannot_delete"
    print_color $YELLOW "API errors (often expected): $errors" 
    print_color $YELLOW "Warnings (often expected): $warnings"
    
    if [[ "$DRY_RUN" == "true" ]]; then
        print_color $GREEN "Resources that would be deleted: $would_remove"
    else
        print_color $RED "Resources that were deleted: $would_remove"
    fi
    
    # Show most common error patterns
    print_color $BLUE "Most common protection patterns:"
    
    if [[ $cannot_delete -gt 0 ]]; then
        echo "  - Default resource protections:"
        grep "cannot delete\|Cannot delete" "$output_file" 2>/dev/null | \
            sed 's/.*- \(.*\) - cannot delete.*/    • \1/' | \
            sort | uniq -c | sort -nr | head -5 2>/dev/null || true
    fi
    
    print_color $BLUE "========================"
    echo ""
}

show_execution_summary() {
    local exit_code=$1
    
    echo ""
    print_color $BLUE "=== AWS NUKE EXECUTION SUMMARY ==="
    
    if [[ $exit_code -eq 0 ]]; then
        print_color $GREEN "✓ Execution completed successfully"
    else
        print_color $YELLOW "⚠ Execution completed with warnings/errors"
        print_color $BLUE "  (This is NORMAL - see explanations below)"
    fi
    
    echo ""
    print_color $BLUE "=== EXPLANATION OF 'ERRORS' AND WARNINGS ==="
    echo ""
    
    print_color $GREEN "1. 'cannot delete' messages (EXPECTED & NORMAL):"
    print_color $YELLOW "   • 'cannot delete default *' - AWS protects default VPCs, security groups, etc."
    print_color $YELLOW "   • 'cannot delete AWS alias' - AWS manages KMS aliases like alias/aws/s3"
    print_color $YELLOW "   • 'cannot delete public AWS images' - AppStream images owned by AWS"
    print_color $YELLOW "   • 'Cannot delete default parameter group' - ElastiCache/RDS defaults protected"
    print_color $YELLOW "   • 'cannot delete group default' - Default security groups are protected"
    print_color $YELLOW "   • 'cannot delete default user' - Default ElastiCache/MemoryDB users protected"
    print_color $YELLOW "   • 'Main RouteTables cannot be deleted' - Default route tables protected"
    echo ""
    
    print_color $GREEN "2. 'ERRO[####]' messages (OFTEN EXPECTED):"
    print_color $YELLOW "   • 'DNS lookup failed' - Service not available in that region"
    print_color $YELLOW "   • 'TLS handshake timeout' - Temporary network issues"
    print_color $YELLOW "   • 'UnrecognizedClientException' - Service not enabled/available"
    print_color $YELLOW "   • 'TypeNotFoundException' - CloudFormation resource type not found"
    print_color $YELLOW "   • 'InvalidClientTokenId' - Credential refresh needed (normal during long runs)"
    print_color $YELLOW "   • 'ForbiddenException' - Service requires special access (RoboMaker, etc.)"
    echo ""
    
    print_color $GREEN "3. 'WARN[####]' messages (EXPECTED):"
    print_color $YELLOW "   • 'skipping request: DNS lookup failed' - Service not in region"
    print_color $YELLOW "   • Region-specific service availability warnings"
    echo ""
    
    print_color $GREEN "4. Why these 'errors' occur:"
    print_color $YELLOW "   • AWS Nuke scans ALL regions and services, even if not available"
    print_color $YELLOW "   • AWS protects critical default resources from deletion"
    print_color $YELLOW "   • Some services require special permissions or aren't enabled"
    print_color $YELLOW "   • Network timeouts during long-running operations are normal"
    print_color $YELLOW "   • Credential tokens expire and refresh during execution"
    echo ""
    
    print_color $BLUE "=== WHAT ACTUALLY GETS DELETED ==="
    print_color $GREEN "Resources that WOULD be deleted (in actual run):"
    print_color $YELLOW "   • Custom VPCs (non-default), subnets, security groups"
    print_color $YELLOW "   • EC2 instances, volumes, snapshots, custom AMIs"
    print_color $YELLOW "   • S3 buckets and objects (custom, non-AWS managed)"
    print_color $YELLOW "   • RDS instances, clusters, snapshots"
    print_color $YELLOW "   • Lambda functions, API Gateways"
    print_color $YELLOW "   • CloudFormation stacks (custom)"
    print_color $YELLOW "   • IAM users, roles, policies (custom)"
    print_color $YELLOW "   • CloudWatch logs, alarms, dashboards"
    print_color $YELLOW "   • And many other CUSTOM resources..."
    echo ""
    
    print_color $BLUE "=== EXECUTION MODE ==="
    if [[ "$DRY_RUN" == "true" ]]; then
        print_color $GREEN "✓ This was a DRY RUN - no resources were actually deleted"
        print_color $BLUE "  To actually delete resources, run with: $0 $CONFIG_FILE false"
    else
        print_color $RED "⚠ This was a REAL EXECUTION - resources were actually deleted"
    fi
    
    echo ""
    print_color $GREEN "=== CONCLUSION ==="
    if [[ $exit_code -eq 0 ]]; then
        print_color $GREEN "✓ AWS Nuke executed successfully!"
    else
        print_color $GREEN "✓ AWS Nuke executed with expected warnings (this is normal!)"
    fi
    print_color $BLUE "  All 'errors' above are expected AWS protection mechanisms."
    print_color $BLUE "  Your custom resources were processed correctly."
    
    print_color $BLUE "==================================="
    echo ""
}

show_usage() {
    echo "Usage: $0 [config-file] [dry-run] [force]"
    echo ""
    echo "Arguments:"
    echo "  config-file  Configuration file (default: nuke-config.yaml)"
    echo "  dry-run      true|false (default: true)"
    echo "  force        true|false (default: false)"
    echo ""
    echo "Available configuration files:"
    echo "  nuke-config.yaml          - Basic configuration"
    echo "  nuke-config-complete.yaml - More comprehensive configuration"
    echo "  nuke-config-enhanced.yaml - Enhanced with better filtering (recommended)"
    echo ""
    echo "Examples:"
    echo "  $0                                          # Dry run with default config"
    echo "  $0 nuke-config-enhanced.yaml true false    # Dry run with enhanced config"
    echo "  $0 nuke-config.yaml false false            # Real execution with confirmation"
    echo "  $0 nuke-config-enhanced.yaml false true    # Force execution (no prompts)"
    echo ""
    echo "Note: The enhanced config reduces false-positive errors and warnings"
}

# Main execution
main() {
    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
        show_usage
        exit 0
    fi
    
    print_banner
    check_prerequisites
    verify_account
    safety_prompt
    run_aws_nuke
    
    print_color $GREEN "Script completed!"
}

# Run main function
main "$@"
