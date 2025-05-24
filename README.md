# Goldsmith
Automating the creation of an immutable server envirrement from golden image to deployment. [Monitoring and automatically testing included??]

## Description
Here are the goals:
1. Create a golden image hosting an ecommerce site. 
2. Validate and distribute the image to a autoscaling group. 
3. Distribute version of software using a pipeline. 
4. Monitor instances using CloudWatch with a dashboard.

## Reset project
Shutdown and delete all AWS test services/instances

## Create golden image
Create pipeline following these steps:
Input: version numbrer dropdown

**Packer - [data stored in csv?? Credentials stored where?]**
1. Create base image of Ubunto linux – security, policy, patching
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