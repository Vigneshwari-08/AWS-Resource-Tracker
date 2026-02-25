#!/bin/bash

###############################
# Author: Vigneshwari
# Date: 19/02/2026
# Version: v1.0
#
# Description:
# This script reports AWS resource usage including:
# - S3 Buckets
# - Running EC2 Instances (All Regions)
# - Lambda Functions
# - IAM Users
#
# Prerequisites:
# - AWS CLI installed
# - AWS CLI configured (aws configure)
###############################

echo "===== AWS RESOURCE USAGE REPORT ====="
echo ""

# List S3 Buckets
echo "S3 Buckets:"
aws s3 ls
echo ""

# List Running EC2 Instances in All Regions
echo "Running EC2 Instances Across All Regions:"
for region in $(aws ec2 describe-regions --query "Regions[].RegionName" --output text); do
  echo "Region: $region"
  aws ec2 describe-instances \
    --region $region \
    --filters "Name=instance-state-name,Values=running" \
    --query "Reservations[].Instances[].{InstanceID:InstanceId,Type:InstanceType,PublicIP:PublicIpAddress}" \
    --output table
done
echo ""

# List Lambda Functions
echo "Lambda Functions:"
aws lambda list-functions --query "Functions[].FunctionName" --output table
echo ""

# List IAM Users
echo "IAM Users:"
aws iam list-users --query "Users[].UserName" --output table
echo ""

echo "===== REPORT COMPLETE ====="
