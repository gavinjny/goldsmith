# Goldsmith
Automating the creation of an immutable server envirrement from golden image to deployment. [Monitoring and automatically testing included??]

## Description
Here are the goals:
1. Create a golden image hosting an ecommerce site. 
2. Validate and distribute the image to a autoscaling group. 
3. Distribute version of software using a pipeline. 
4. Monitor instances using CloudWatch with a dashboard.

## Reset Project
Shutdown and delete all EC2 instances

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
            i. Compliance – OPENSCAP
            ii. Latest patches 
            iii. Application meta data validation – ansible
            iv. Confirms image metadata - Ansible test modules (assert, setup) or InSpec
        1. Functionality 
            i. Services running - Ansible
            ii. Synthetic checks - Playwrite
    1. Build success?
        i. Yes - Tag successful build
        ii. No – Delete image
2. Create child image – role specific changes(web, db)
    a. Run Ansible to customize server
    b. Install Prestashop (https://assets.prestashop3.com/dst/edition/corporate/8.2.0/prestashop_edition_classic_version_8.2.0.zip or https://github.com/PrestaShop/PrestaShop/releases/download/1.7.8.11/prestashop_1.7.8.11.zip)
    c. Test deployment
        a. Security - Lynis (lightweight, Linux-specific)
        b. Application Configuration - Ansible test modules (assert, setup) or InSpec
            i. Compliance – OPENSCAP
            ii. Latest patches 
            iii. Application meta data validation – ansible
            iv. Confirms image metadata - Ansible test modules (assert, setup) or InSpec
        c. Functionality 
            i. Services running - Ansible
            ii. Synthetic checks – Playwrite
    d. Build success?
        i. Yes - Tag successful build
        ii. No – Delete image

## Distribute golden image
**Terraform**
    1. Canary deployment of the latest build
    2. Create autoscaling group

## Monitor instances
**CloudWatch dashboard**
    1. Golden signals
    2. Test results

## Incident tracking
**Ansible**
    1. Send P1 errors to Teams
    2. Create Trello issues with all errors
