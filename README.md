# Terraform-FunctionApp

# Setup Steps:
1. Create Resource Group:
   
az group create --name rg-func-dev --location "Central India"

2. Create App Service Plan (Free Tier)
az appservice plan create \
  --name asp-common-dev \
  --resource-group rg-funcproject-dev \
  --sku Y1
    
3. Configure Variables - Update “.tfvars” files with your Azure details:

# Deployment Steps:
1. Initialize Terraform
terraform init

2. Validate Configuration
terraform validate

3. Plan Deployment
terraform plan

4. Apply Deployment
terraform apply
Type yes when prompted.
