#!/bin/bash

#######################
# Author: Vigneshwari
# Date: 19/02/2026
#
# Version: v1
#
# This script will report the AWS resources usage
######################

# AWS S3, EC2, Lambda, IAM users

# list s3 buckets
aws s3 ls

# list EC2 instances
for region in $(aws ec2 describe-regions --query "Regions[].RegionName" --output text); do
  aws ec2 describe-instances \
    --region $region \
    --filters "Name=instance-state-name,Values=running" \
    --query "Reservations[].Instances[].{Region:'$region',ID:InstanceId,Type:InstanceType,PublicIP:PublicIpAddress}" \
    --output table
done

#list Lambda 
aws lambda list-functions

#list IAM users
aws iam list-users

