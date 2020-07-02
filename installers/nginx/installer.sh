#!/bin/sh
      
CURL_CMD=$(which curl) # curl tool
YUM_CMD=$(which yum) # yum package manager for RHEL & CentOS
DNF_CMD=$(which dnf) # dnf package manager for new RHEL & CentOS
APT_GET_CMD=$(which apt-get) # apt package manager for Ubuntu & other Debian based distributions
PACMAN_CMD=$(which pacman) # pacman package manager for ArchLinux
APK_CMD=$(which apk) # apk package manager for Alpine
GIT_CMD=$(which git) # to build from source pulling from git
SUDO_CMD=$(which sudo) # check if sudo command is there

USER="$(id -un 2>/dev/null || true)"
SUDO=''
if [ "$USER" != 'root' ]; then
	if [ ! -z $SUDO_CMD ]; then
		SUDO='sudo'
	else
		cat >&2 <<-'EOF'
		Error: this installer needs the ability to run commands as root.
		We are unable to find "sudo". Make sure its available to make this happen
		EOF
		exit 1
	fi
fi

if [ ! -z $APT_GET_CMD ]; then
   sudo apt-get update
   sudo apt-get install nginx
   
elif [ ! -z $YUM_CMD ]; then
   sudo yum install nginx
   
elif [ ! -z $PACMAN_CMD ]; then
   $SUDO pacman -S nginx
   
elif [ ! -z $APK_CMD ]; then
   sudo apk update
   sudo apk add nginx
   
elif [ ! -z $DNF_CMD ]; then
   sudo dnf install nginx
   
else
   echo "Couldn't install package"
   exit 1;
fi