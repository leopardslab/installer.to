#!/bin/sh


APT_GET_CMD=$(which apt-get) # apt package manager for Ubuntu & other Debian based distributions
DNF_CMD=$(which dnf) # dnf package manager for new RHEL & CentOS
YUM_CMD=$(which yum) # yum package manager for RHEL & CentOS
PACMAN_CMD=$(which pacman) # pacman package manager for ArchLinux
APK_CMD=$(which apk) # apk package manager for Alpine

 if [ ! -z $APT_GET_CMD ]; then
    sudo apt-get update 
    sudo apt-get upgrade
    sudo apt-get install ffmpeg ffmpeg-devel
 elif [ ! -z $DNF_CMD ]; then
    sudo dnf -y install https://download.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
    sudo dnf localinstall --nogpgcheck https://download1.rpmfusion.org/free/el/rpmfusion-free-release-8.noarch.rpm
    sudo dnf install --nogpgcheck https://download1.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-8.noarch.rpm
    sudo dnf install http://rpmfind.net/linux/epel/7/x86_64/Packages/s/SDL2-2.0.10-1.el7.x86_64.rpm
    sudo dnf install ffmpeg
    sudo dnf -y install ffmpeg-devel
 elif [ ! -z $YUM_CMD ]; then
    sudo yum install epel-release     
    sudo rpm -v --import http://li.nux.ro/download/nux/RPM-GPG-KEY-nux.ro
    sudo rpm -Uvh http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-5.el7.nux.noarch.rpm
    sudo yum install ffmpeg ffmpeg-devel
 elif [ ! -z $PACMAN_CMD ]; then
    pacman -Syu ffmpeg
 elif [ ! -z $APK_CMD ]; then
    sudo apk add --no-cache ffmpeg
 else
    echo "Couldn't install package"
    exit 1;
 fi

ffmpeg -version