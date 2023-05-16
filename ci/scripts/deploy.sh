#!/bin/bash
set -euo pipefail

# Out out of AWS data collection
export SAM_CLI_TELEMETRY=0

aws_region="ap-southeast-2"
projectStackName="youtube-sentiment"
deploymentBucketStackName="${projectStackName}-deploy-bucket"
deploymentBucketName="${deploymentBucketStackName}-${ACCOUNT_ID}"


# echo "## Deleting Stack"
# aws cloudformation delete-stack --stack-name $projectStackName


echo ""
echo "# [Deploy] S3 Bucket for Deployment Artifacts..."
{
  aws cloudformation deploy \
    --template-file infrastructure/deployment-bucket.yml \
    --stack-name ${deploymentBucketStackName} \
    --capabilities CAPABILITY_IAM \
    --no-fail-on-empty-changeset \
    --parameter-overrides DeploymentBucketName="${deploymentBucketName}"
} || {
  echo "## Error deploying S3 Bucket for Deployment"
  aws cloudformation describe-stack-events \
    --stack-name ${deploymentBucketStackName} \
    --query 'StackEvents[*].[Timestamp,LogicalResourceId,ResourceStatus,ResourceStatusReason]' \
    --output table
  exit -1
}


echo ""
echo "# [Deploy] SAM services as nested stack..."
{
  sam deploy \
    --template-file infrastructure/master.yml \
    --stack-name ${projectStackName} \
    --s3-bucket ${deploymentBucketName} \
    --region ${aws_region} \
    --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM CAPABILITY_AUTO_EXPAND \
    --no-confirm-changeset \
    --no-fail-on-empty-changeset
} || {
  echo "## Error deploying SAM services"
  aws cloudformation describe-stack-events \
    --stack-name ${projectStackName} \
    --query 'StackEvents[*].[Timestamp,LogicalResourceId,ResourceStatus,ResourceStatusReason]' \
    --output table
  exit -1
}
