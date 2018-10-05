#!/usr/bin/env bash
distro=$(gawk -F= '/^NAME/{print $2}' /etc/os-release)
intended_distro=\"Ubuntu\"
TERRAFORM_VERSION=0.11.8
TERRAFORM_ARCHITECTURE=amd64
TERRAFORM_HOME=/opt/terraform
TEMP_INSTALL_DIR=/tmp
TERRAFORM_CONFIG_SUBDIR=config

if [[ ${distro} != ${intended_distro} ]]; then echo "This script should run on the Ubuntu distribution"; exit 1; fi # checks whether the distro is Ubuntu
if [[ ${EUID} -ne 0 ]]; then echo "This script must be run as root"; exit 1; fi # checks whether the user is root

# install basic packages
echo "Updating packages..." && apt-get update -y
echo "Installing basic packages..." && apt-get install -y git wget unzip

# install terraform
## removing old versions
if [ -d "$TERRAFORM_HOME" ]; then
  rm -rf $TERRAFORM_HOME
fi

## installing terraform
wget -NP ${TEMP_INSTALL_DIR} https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_${TERRAFORM_ARCHITECTURE}.zip
unzip -o ${TEMP_INSTALL_DIR}/terraform_${TERRAFORM_VERSION}_linux_${TERRAFORM_ARCHITECTURE}.zip -d ${TERRAFORM_HOME}
export PATH=${PATH}:${TERRAFORM_HOME}
echo PATH=\"${PATH}\" > /etc/environment

# pulling the config
echo "This script assumes an existing terraform configuration repository (git), containing .tf terraform configuration files"
read -e -p 'please input your Terraform configuration repository (git): ' TERRAFORM_CONFIG_REPO

git clone ${TERRAFORM_CONFIG_REPO} ${TERRAFORM_HOME}/${TERRAFORM_CONFIG_SUBDIR}
cd ${TERRAFORM_HOME}/${TERRAFORM_CONFIG_SUBDIR}

## creating a tag
grep -q -F "APP=Terraform" /etc/environment || echo "APP=Terraform" >> /etc/environment

# verify
echo ""
terraform --version

# cleanup
rm -f ${TEMP_INSTALL_DIR}/terraform_${TERRAFORM_VERSION}_linux_${TERRAFORM_ARCHITECTURE}.zip