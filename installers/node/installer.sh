#!/bin/sh
      
YUM_CMD=$(which yum) # yum package manager for RHEL & CentOS
DNF_CMD=$(which dnf) # dnf package manager for new RHEL & CentOS
APT_GET_CMD=$(which apt-get) # apt package manager for Ubuntu & other Debian based distributions
PACMAN_CMD=$(which pacman) # pacman package manager for ArchLinux
APK_CMD=$(which apk) # apk package manager for Alpine
GIT_CMD=$(which git) # to build from source pulling from git

if [ ! -z $APT_GET_CMD ]; then
   if [  -n "$(uname -a | grep Ubuntu)" ]; then
       curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
       sudo apt-get install -y nodejs
   else
       curl -sL https://deb.nodesource.com/setup_12.x | bash -
       sudo apt-get install -y nodejs
   fi
   
elif [ ! -z $YUM_CMD ]; then
   sudo yum install nodejs12
   
elif [ ! -z $DNF_CMD ]; then
   sudo dnf install -y gcc-c++ make
   curl -sL https://rpm.nodesource.com/setup_12.x | sudo -E bash -
   sudo dnf install nodejs
   
elif [ ! -z $APK_CMD ]; then
   sudo apk update
   sudo apk add nodejs
   
else
   echo "Couldn't install package"
   exit 1;
fi