#!/bin/bash
set -euo pipefail

# For Mechancial Rock sandbox deploy testing
# Before using this, you need to paste into your cli the AWS environment variables from your MR SSO login. Will be similar to:
# export AWS_ACCESS_KEY_ID="QWERTYUIOP"
# export AWS_SECRET_ACCESS_KEY="ASDFGHJKL"
# export AWS_SESSION_TOKEN="SOME-REALLY-LONG-STRING"

export AWS_REGION=ap-southeast-2
echo ""
echo "Using AWS_REGION: ${AWS_REGION}"

# Get account id for the cli user's AWS env variables
response_accunt_id=$(aws sts get-caller-identity --query Account --output text)
export ACCOUNT_ID=${response_accunt_id}

# Build before deploying - needed to build lambda layer dependencies.
./ci/scripts/build.sh

echo ""
echo "# [Deploy] Infrastructure into Sandbox account ID: ${ACCOUNT_ID} ..."
# Needs to be sourced to get alias expanding to work.
. ./ci/scripts/deploy.sh
