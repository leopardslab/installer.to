#!/bin/sh

YUM_CMD=$(which yum) # yum package manager for RHEL & CentOS
DNF_CMD=$(which dnf) # dnf package manager for new RHEL & CentOS
APT_GET_CMD=$(which apt-get) # apt package manager for Ubuntu & other Debian based distributions
PACMAN_CMD=$(which pacman) # pacman package manager for ArchLinux
APK_CMD=$(which apk) # apk package manager for Alpine

 if [ ! -z $APT_GET_CMD ]; then
    sudo apt-get update
    sudo apt-get install android-sdk
 elif [ ! -z $APK_CMD ]; then
    sudo apk add --no-cache bash unzip libstdc++
    mkdir -p /opt/android-sdk && cd /opt/android-sdk
    && wget -q http://dl.google.com/android/repository/tools_r27.0.0-linux.zip -O android-sdk-tools.zip
    && unzip -q android-sdk-tools.zip -d /opt/android-sdk
    && rm -f android-sdk-tools.zip
    && chmod 777 /opt/android-sdk/*
    && echo y | android update sdk -a --no-ui --filter build-tools-25.0.2
 elif [ ! -z $PACMAN_CMD ]; then
    sudo pacman -S --needed base-devel git wget yajl
    cd /tmp && git clone https://aur.archlinux.org/package-query.git
    cd package-query/ && makepkg -si
    cd /tmp/ && git clone https://aur.archlinux.org/yaourt.git
    cd yaourt/ && makepkg si
    yaourt -S android-sdk android-sdk-platform-tools android-sdk-build-tools
    sudo touch /tmp/script.sh
    cat <<EOF > /tmp/script.sh
    export ANDROID_HOME=/opt/android-sdk
    export PATH=$PATH:$ANDROID_HOME/tools
    export PATH=$PATH:$ANDROID_HOME/platform-tools
    EOF
    source /tmp/script.sh
    sudo rm /tmp/script.sh
 else
    echo "Couldn't install package"
    exit 1;
 fi