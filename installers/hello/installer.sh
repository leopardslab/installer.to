#!/bin/sh
      
YUM_CMD=$(which yum) # yum package manager for RHEL & CentOS
DNF_CMD=$(which dnf) # dnf package manager for new RHEL & CentOS
APT_GET_CMD=$(which apt-get) # apt package manager for Ubuntu & other Debian based distributions
PACMAN_CMD=$(which pacman) # pacman package manager for ArchLinux
APK_CMD=$(which apk) # apk package manager for Alpine
GIT_CMD=$(which git) # to build from source pulling from git

if [ ! -z $APT_GET_CMD ]; then
   echo "Installing hello"
   echo "Installed hello"
   
elif [ ! -z $YUM_CMD ]; then
   echo "Installing hello"
   echo "Installed hello"
   
elif [ ! -z $APK_CMD ]; then
   echo "Installing hello"
   echo "Installed hello"
   
elif [ ! -z $DNF_CMD ]; then
   echo "Installing hello"
   echo "Installed hello"
   
else
   echo "Couldn't install package"
   exit 1;
fi