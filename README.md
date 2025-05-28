# About
This project is a demonstration Github pipeline(Goldsmith) to create, update and deploy a golden image for a fictitious company (Storefront). The pipeline modifies AWS AMI, EC2, ASG, ALB, Cloudwatch. [Monitoring and automatic testing included??]

**Features**
1.	Updates golden image and EC2s on AWS
2.	Creates new or use existing golden image
2.  Deploys Ubuntu EC2 using canary deployment
3.	Automated testing of images
4.	Automated end to end
5.	Application management
6.	Monitoring with CloudWatch
7.	Notification via Trello
8.	Escalated user support

**Skills**
1.	Bash
1.	Ansible
1.	Terraform 
1.	Packer
1.	Linux 
1.	Debugging
1.	SSH certification usage
1. Git Actions pipeline
1. AWS (EC2, AMI, ASG, ALB, IAM, Cloudwatch)
1. MySQL
1. Yaml
1. HCL
1. Linux
1. Credential security


## Goals:
1. Create or update a golden image hosting an ecommerce site (Storefront). 
2. Validate and distribute the image to a autoscaling group. 
3. Distribute version of software using a pipeline. 
4. Monitor instances using CloudWatch with a dashboard.
[diagram does here]


# Getting Started
[Go to ________ and do blah]

## Input
- Storefront version

Deploys:
 - New
 - Existing image
    - Version of selected image
GitHub Variables:
[]

GitHub Secrets:
[]

# Pipeline actions
## Create golden image
Create pipeline following these steps. All steps use Packer
1. Create or update Ubuntu base image
    1. Change timezone
    1. Update software
    1. Test deployment
        1. Security - Lynis (lightweight, Linux-specific)
        1. Application Configuration - Ansible test modules (assert, setup) or InSpec
            1. Compliance – OPENSCAP
            1. Latest patches 
            1. Application meta data validation – ansible
            1. Confirms image metadata - Ansible test modules (assert, setup) or InSpec
        1. Functionality 
            1. Services running - Ansible
            1. Synthetic checks - Playwrite
    1. Build success?
        1. Yes - Tag successful build
        1. No – Delete image
1. Create child image – role specific changes(web, db)
    1. Run Ansible to customize server
    1. Install Prestashop (https://assets.prestashop3.com/dst/edition/corporate/8.2.0/prestashop_edition_classic_version_8.2.0.zip or https://github.com/PrestaShop/PrestaShop/releases/download/1.7.8.11/prestashop_1.7.8.11.zip)
    1. Test deployment
        1. Security - Lynis (lightweight, Linux-specific)
        1. Application Configuration - Ansible test modules (assert, setup) or InSpec
            1. Compliance – OPENSCAP
            1. Latest patches 
            1. Application meta data validation – ansible
            1. Confirms image metadata - Ansible test modules (assert, setup) or InSpec
        1. Functionality 
            1. Services running - Ansible
            1. Synthetic checks – Playwrite
    1. Build success?
        1. Yes - Tag successful build
        1. No – Delete image

## Distribute golden image
**Terraform**
1. Canary deployment of the latest build - ALB
1. Create autoscaling group - ASG

## Setup dashboard
**Terraform**
1. Golden signals - CloudWatch
1. Test results - CloudWatch

## Setup incident tracking
**Terraform**
1. Alerts teams - CloudWatch
1. Create Trello issue with failure results - CloudWatch

## Reset of AWS environment
Shutdown and delete all AWS test services/instances
Purpose:
- Ensures I dont get charged for unused AWS instances and services
- Reset AWS assets to zero to show process can run from scratch