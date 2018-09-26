#!/usr/bin/env bash

if [[ ${distro} != ${intended_distro} ]]; then echo "This script should run on the Ubuntu distribution"; exit 1; fi # checks whether the distro is Ubuntu
if [[ ${EUID} -ne 0 ]]; then echo "This script must be run as root"; exit 1; fi # checks whether the user is root

ssh-keygen -o -a 100 -t ed25519 -f ~/.ssh/id_ed25519 -q -N ""

echo "Please distribute the ssh pubkey to the relevant services:"
cat ~/.ssh/id_ed25519.pub