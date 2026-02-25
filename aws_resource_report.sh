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
#########################################
# AWS Resource Usage Reporter
# Author: Vigneshwari
# Version: v3.0
#########################################

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Counters
TOTAL_EC2=0
TOTAL_LAMBDA=0
TOTAL_S3=0
TOTAL_IAM=0

echo -e "${GREEN}==========================================="
echo -e "        AWS RESOURCE USAGE REPORT"
echo -e "Generated on: $(date)"
echo -e "===========================================${NC}"
echo ""

# Check AWS CLI configuration
if ! aws sts get-caller-identity > /dev/null 2>&1; then
    echo -e "${RED}AWS CLI not configured properly!${NC}"
    exit 1
fi

############################
# S3 Buckets
############################
echo -e "${GREEN} S3 Buckets${NC}"
echo "-------------------------------------------"

S3_LIST=$(aws s3 ls)
if [ -n "$S3_LIST" ]; then
    echo "$S3_LIST"
    TOTAL_S3=$(echo "$S3_LIST" | wc -l)
else
    echo "No S3 buckets found."
fi
echo ""

############################
# EC2 Instances
############################
echo -e "${GREEN} Running EC2 Instances (All Regions)${NC}"
echo "-------------------------------------------"

for region in $(aws ec2 describe-regions --query "Regions[].RegionName" --output text); do
  INSTANCES=$(aws ec2 describe-instances \
    --region "$region" \
    --filters "Name=instance-state-name,Values=running" \
    --query "Reservations[].Instances[]" \
    --output text)

  if [ -n "$INSTANCES" ]; then
    echo -e "${BLUE}Region: $region${NC}"
    
    COUNT=$(aws ec2 describe-instances \
      --region "$region" \
      --filters "Name=instance-state-name,Values=running" \
      --query "length(Reservations[].Instances[])" \
      --output text)

    TOTAL_EC2=$((TOTAL_EC2 + COUNT))

    aws ec2 describe-instances \
      --region "$region" \
      --filters "Name=instance-state-name,Values=running" \
      --query "Reservations[].Instances[].{InstanceID:InstanceId,PublicIP:PublicIpAddress,Type:InstanceType}" \
      --output table

    echo -e "${YELLOW}Instances in $region: $COUNT${NC}"
    echo ""
  fi
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
############################
# Lambda Functions
############################
echo -e "${GREEN} Lambda Functions (All Regions)${NC}"
echo "-------------------------------------------"

for region in $(aws ec2 describe-regions --query "Regions[].RegionName" --output text); do
  COUNT=$(aws lambda list-functions \
    --region "$region" \
    --query "length(Functions[])" \
    --output text 2>/dev/null)

  if [ "$COUNT" != "0" ] && [ -n "$COUNT" ]; then
    echo -e "${BLUE}Region: $region${NC}"

    TOTAL_LAMBDA=$((TOTAL_LAMBDA + COUNT))

    aws lambda list-functions \
      --region "$region" \
      --query "Functions[].FunctionName" \
      --output table

    echo -e "${YELLOW}Lambda functions in $region: $COUNT${NC}"
    echo ""
  fi
done

############################
# IAM Users
############################
echo -e "${GREEN} IAM Users${NC}"
echo "-------------------------------------------"

IAM_LIST=$(aws iam list-users --query "Users[].UserName" --output text)
if [ -n "$IAM_LIST" ]; then
    aws iam list-users --query "Users[].UserName" --output table
    TOTAL_IAM=$(echo "$IAM_LIST" | wc -w)
else
    echo "No IAM users found."
fi

echo ""

############################
# FINAL SUMMARY
############################
echo -e "${GREEN}==========================================="
echo -e "              SUMMARY"
echo -e "===========================================${NC}"

echo -e "${YELLOW}Total S3 Buckets:     $TOTAL_S3${NC}"
echo -e "${YELLOW}Total EC2 Instances:  $TOTAL_EC2${NC}"
echo -e "${YELLOW}Total Lambda:         $TOTAL_LAMBDA${NC}"
echo -e "${YELLOW}Total IAM Users:      $TOTAL_IAM${NC}"

echo -e "${GREEN}===========================================${NC}"

############################
# GMAIL ALERT (msmtp)
############################

EMAIL="eshu.vk@gmail.com"

if [ "$TOTAL_EC2" -gt 0 ] || [ "$TOTAL_LAMBDA" -gt 0 ]; then

  SUBJECT="AWS Resource Alert"
  
  BODY="AWS Resource Alert

EC2 Running: $TOTAL_EC2
Lambda Functions: $TOTAL_LAMBDA
S3 Buckets: $TOTAL_S3
IAM Users: $TOTAL_IAM

Generated on: $(date)
"

  {
    echo "From: $EMAIL"
    echo "To: $EMAIL"
    echo "Subject: $SUBJECT"
    echo ""
    echo "$BODY"
  } | msmtp $EMAIL

  echo "Gmail notification sent successfully."

else
  echo "No active EC2 or Lambda resources. Email skipped."
fi
