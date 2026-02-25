# 🚀 AWS Resource Monitoring & Email Alert Automation (Bash + AWS CLI)

## 📌 Overview

This Bash-based automation tool scans and reports AWS resource usage across an entire AWS account, including all AWS regions.

The script generates a structured, timestamped resource usage report and automatically sends it via Gmail using `msmtp` for reliable and secure SMTP delivery.

This solution helps improve cloud visibility, prevent unnecessary AWS charges, and automate infrastructure monitoring.

---

## 🔎 Features

The script retrieves and reports:

- ✅ S3 Buckets
- ✅ Running EC2 Instances (All AWS Regions)
- ✅ Lambda Functions
- ✅ IAM Users
- ✅ Per-region EC2 instance summary counts
- ✅ Color-formatted terminal output
- ✅ Timestamped report file generation
- ✅ Automatic Gmail email report delivery

---

## ✉️ Gmail Alert Integration

The script integrates with Gmail using:

- `msmtp` for secure SMTP transmission
- Gmail App Password authentication
- Automated email subject and message formatting
- Timestamped report attachment

This ensures reliable email notifications without relying on a local mail server.

---

## 🛠 Prerequisites

Before running the script, ensure the following are configured:

- AWS CLI installed
- AWS CLI configured (`aws configure`)
- Proper IAM permissions:
  - `ec2:DescribeInstances`
  - `s3:ListBuckets`
  - `lambda:ListFunctions`
  - `iam:ListUsers`
- `msmtp` installed
- Gmail App Password generated and configured

---

## 🚀 How to Use

1. Clone the repository:
   git clone https://github.com/Vigneshwari-08/aws-resource-usage-report.git

2. Make the script executable:
   chmod +x aws-resource-report.sh

3. Run the script:
   ./aws-resource-report.sh

## 📂 Technologies Used

- Bash Scripting
- AWS CLI
- IAM Policies
- msmtp (SMTP email automation)
- Linux CLI tools

## 🎯 Purpose

This project demonstrates:
- AWS CLI automation
- Multi-region EC2 scanning logic
- Cloud cost-awareness tooling
- Secure email integration via SMTP
- Shell scripting best practices
- DevOps-style automation workflows

## 📈 Real-World Use Case
- Prevent unexpected AWS billing
- Monitor Free Tier usage
- Automate cloud visibility reporting
- Lightweight alternative to paid monitoring tools

---

Author: Vigneshwari
