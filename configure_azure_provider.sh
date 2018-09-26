#!/usr/bin/env bash

# install azure CLI
if ! az --version > /dev/null; then
    echo "Azure CLI not found"
    echo "Installing Azure CLI now..."
    ### Modify your sources list:
    AZ_REPO=$(lsb_release -cs); echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | sudo tee /etc/apt/sources.list.d/azure-cli.list
    ### Get the Microsoft signing key:
    curl -L https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
    ### Install the CLI:
    sudo apt-get install apt-transport-https; sudo apt-get update && sudo apt-get install azure-cli
else
    echo "Azure CLI found"
fi

# configure azure CLI
echo "Configuring Azure CLI..."
az login
az account list

echo "Setting Azure provider environment variables for Terraform..."
read -e -p 'please input your Azure Subscription ID: '  ARM_SUBSCRIPTION_ID 
read -e -p 'please input your Azure Client ID: '  ARM_CLIENT_ID 
read -e -p 'please input your Azure Client Secret/Password: '  ARM_CLIENT_SECRET 
read -e -p 'please input your Azure Tenant ID: '  ARM_TENANT_ID 

az account set --subscription $ARM_SUBSCRIPTION_ID