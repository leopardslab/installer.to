#!/bin/sh


#Downloading the installer file directly from official repo of halyard
curl -O https://raw.githubusercontent.com/spinnaker/halyard/master/install/debian/InstallHalyard.sh

#Running the bash script
sudo bash InstallHalyard

#Verifying the install
hal -v

#To enable command completion
. ~/.bashrc