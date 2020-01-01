#!/bin/sh

YUM_CMD=$(which yum) # yum package manager for RHEL & CentOS
DNF_CMD=$(which dnf) # dnf package manager for new RHEL & CentOS
APT_GET_CMD=$(which apt-get) # apt package manager for Ubuntu & other Debian based distributions
PACMAN_CMD=$(which pacman) # pacman package manager for ArchLinux
APK_CMD=$(which apk) # apk package manager for Alpine

 if [ ! -z $APT_GET_CMD ]; then
    sudo apt update
    sudo apt install software-properties-common apt-transport-https wget
    wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
    sudo apt update
    sudo apt install code
 elif [ ! -z $DNF_CMD ]; then
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
    sudo dnf check-update
    sudo dnf install code
 elif [ ! -z $YUM_CMD ]; then
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo yum check-update
    sudo yum install code
 elif [ ! -z $PACMAN_CMD ]; then
    sudo pacman -Sy
    sudo pacman -S git
    cd ~/Downloads
    git clone https://AUR.archlinux.org/visual-studio-code-bin.git
    cd visual-studio-code-bin/
    makepkg -s
    sudo pacman -U visual-studio-code-bin-*.pkg.tar.xz
    cd ../ && sudo rm -rfv visual-studio-code-bin/
 elif [ ! -z $APK_CMD ]; then
    echo "Visual Studio Code does not officially support Alpine Linux. In order to install, you must patch Alpine with glibc and install all apk pre-requisites."
 else
    echo "Couldn't install package"
    exit 1;
 fi

code