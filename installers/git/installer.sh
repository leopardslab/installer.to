#!/bin/sh

YUM_CMD=$(which yum) # yum package manager for RHEL & CentOS
DNF_CMD=$(which dnf) # dnf package manager for new RHEL & CentOS
APT_GET_CMD=$(which apt-get) # apt package manager for Ubuntu & other Debian based distributions
PACMAN_CMD=$(which pacman) # pacman package manager for ArchLinux
APK_CMD=$(which apk) # apk package manager for Alpine

USER="$(id -un 2>/dev/null || true)"
PREFIX=''
if [ "$USER" != 'root' ]; then
	if command_exists sudo; then
		PREFIX='sudo'
	else
		cat >&2 <<-'EOF'
		Error: this installer needs the ability to run commands as root.
		We are unable to find "sudo"  available to make this happen.
		EOF
		exit 1
	fi
fi

 if [ ! -z $APT_GET_CMD ]; then
    $PREFIX apt-get update
    $PREFIX apt-get install git
 elif [ ! -z $DNF_CMD ]; then
    $PREFIX dnf install git
 elif [ ! -z $YUM_CMD ]; then
    $PREFIX yum install git
 elif [ ! -z $PACMAN_CMD ]; then
    pacman -Sy git
 elif [ ! -z $APK_CMD ]; then
    $PREFIX apk add git
 else
    echo "Couldn't find an installer matching to this package"
    exit 1;
 fi

git --version
