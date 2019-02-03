#!/bin/sh

YUM_CMD=$(which yum) # yum package manager for RHEL & CentOS
DNF_CMD=$(which dnf) # dnf package manager for new RHEL & CentOS
APT_GET_CMD=$(which apt-get) # apt package manager for Ubuntu & other Debian based distributions
PACMAN_CMD=$(which pacman) # pacman package manager for ArchLinux
APK_CMD=$(which apk) # apk package manager for Alpine

 if [ ! -z $APT_GET_CMD ]; then
    sudo apt-get update
    sudo apt-get install git
 elif [ ! -z $DNF_CMD ]; then
    sudo dnf install git
 elif [ ! -z $YUM_CMD ]; then
    sudo yum install git
 elif [ ! -z $PACMAN_CMD ]; then
    pacman -Sy git
 elif [ ! -z $APK_CMD ]; then
    sudo apk add git
 else
    echo "Couldn't install package"
    exit 1;
 fi

git --version
