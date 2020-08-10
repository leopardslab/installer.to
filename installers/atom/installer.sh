#!/bin/sh

YUM_CMD=$(which yum) # yum package manager for RHEL & CentOS
DNF_CMD=$(which dnf) # dnf package manager for new RHEL & CentOS
APT_GET_CMD=$(which apt-get) # apt package manager for Ubuntu & other Debian based distributions
PACMAN_CMD=$(which pacman) # pacman package manager for ArchLinux
APK_CMD=$(which apk) # apk package manager for Alpine

 if [ ! -z $APT_GET_CMD ]; then
    wget -qO - https://packagecloud.io/AtomEditor/atom/gpgkey | sudo apt-key add -
    sudo sh -c 'echo "deb [arch=amd64] https://packagecloud.io/AtomEditor/atom/any/ any main" > /etc/apt/sources.list.d/atom.list'
    sudo apt-get update
    sudo apt-get install atom
 elif [ ! -z $DNF_CMD ]; then
    sudo rpm --import https://packagecloud.io/AtomEditor/atom/gpgkey
    sudo sh -c 'echo -e "[Atom]\nname=Atom Editor\nbaseurl=https://packagecloud.io/AtomEditor/atom/el/7/\$basearch\nenabled=1\ngpgcheck=0\nrepo_gpgcheck=1\ngpgkey=https://packagecloud.io/AtomEditor/atom/gpgkey" > /etc/yum.repos.d/atom.repo'
    sudo dnf install atom
 elif [ ! -z $YUM_CMD ]; then
    sudo rpm --import https://packagecloud.io/AtomEditor/atom/gpgkey
    sudo sh -c 'echo -e "[Atom]\nname=Atom Editor\nbaseurl=https://packagecloud.io/AtomEditor/atom/el/7/\$basearch\nenabled=1\ngpgcheck=0\nrepo_gpgcheck=1\ngpgkey=https://packagecloud.io/AtomEditor/atom/gpgkey" > /etc/yum.repos.d/atom.repo'
    sudo dnf install atom
 elif [ ! -z $PACMAN_CMD ]; then
    sudo pacman -S atom
 elif [ ! -z $APK_CMD ]; then
    sudo apk add atom
 else
    echo "Couldn't install package"
    exit 1;
 fi

atom --version
