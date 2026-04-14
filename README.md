# Deploy multiple Azure Function Apps using Terraform

---

## Introduction

This project explains how to deploy multiple **Azure Function Apps using Terraform** with **modules and environment-based approach**.


## Project Architecture

```
Root Module
   ↓
Module: function_app
   ↓
Azure Resources
```

---

## Project Structure Explained

```
.
├── modules/
│   └── function_app/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
│
├── main.tf
├── variables.tf
├── outputs.tf
├── providers.tf
├── locals.tf
│
├── terraform.dev.tfvars
├── terraform.uat.tfvars
```

### modules/function_app

* Contains reusable Terraform code
* Helps maintain clean and scalable infrastructure

### Root Files

* `main.tf` → Calls module
* `variables.tf` → Global variables
* `outputs.tf` → Final outputs
* `providers.tf` → Azure provider config
* `locals.tf` → Reusable values

### tfvars Files

* Used for environment-specific configurations:

  * Dev
  * UAT

---

## Prerequisites

Before running this project, ensure the following resources are already created in Azure:

* Resource Group
```
az group create \
  --name rg-funcproject-dev \
  --location centralindia
```
* App Service Plan

These are **pre-existing shared resources**, and this project will use them to deploy multiple Azure Function Apps.

Also ensure:

* Terraform is installed
* Azure CLI is installed
* You have access to the Azure Subscription

## Step 1: Login to Azure

```
az login
```

---

## Step 2: Initialize Terraform

```
terraform init
```

This command downloads required providers and initializes the working directory.

---

## Step 3: Validate Configuration

```
terraform validate
```

---

## Step 4: Plan Deployment

### For Dev:

```
terraform plan -var-file="terraform.dev.tfvars"
```

### For UAT:

```
terraform plan -var-file="terraform.uat.tfvars"
```

---

## Step 5: Apply Configuration

### For Dev:

```
terraform apply -var-file="terraform.dev.tfvars"
```

### For UAT:

```
terraform apply -var-file="terraform.uat.tfvars"
```

---


## Key Concepts Used

### Modules

Modules allow you to reuse infrastructure code across environments.

### Variables & tfvars

* Variables define inputs
* `.tfvars` files provide environment-specific values

### Locals

Used to simplify expressions and reuse values.

---

## Multi-Environment Deployment

This project supports:

* Dev Environment
* UAT Environment

Each environment uses a separate `.tfvars` file.

---

## Best Practices Followed

* Modular structure
* Environment separation
* Clean code organization
* Reusability

---

## Future Enhancements

* Add Azure DevOps CI/CD pipeline
* Remote backend (Azure Storage)
* Application Insights integration
* Key Vault for secrets management

---



