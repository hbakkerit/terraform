#!/usr/bin/env bash

if [[ ${distro} != ${intended_distro} ]]; then echo "This script should run on the Ubuntu distribution"; exit 1; fi # checks whether the distro is Ubuntu
if [[ ${EUID} -ne 0 ]]; then echo "This script must be run as root"; exit 1; fi # checks whether the user is root

echo "Prerequisites: "
echo "- an existing terraform configuration repository (git), containing .tf terraform configuration files"
echo "- a Personal Access Token or API key for the service provider you are trying to use (Azure/AWS/etc)"
echo ""
echo "Press any key to continue.."
read

# make all scripts executable
chmod 750 ./*.sh

# install terraform
./install_terraform.sh

# generate ssh key
./generate_ssh_key.sh

read -p "Do you want to configure Digital Ocean as a provider for Terraform (y/n)? " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
# configure terraform for digital ocean
./configure_digital_ocean_provider.sh
fi

read -p "Do you want to configure Azure as a provider for Terraform (y/n)? " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
# configure terraform for digital ocean
./configure_azure_provider.sh
fi

# finish
echo "Install script finished, go to ${TERRAFORM_HOME}/${TERRAFORM_CONFIG_SUBDIR} to find your configuration"
echo "Please logoff and logon again for the changes to take place"