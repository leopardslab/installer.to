#!/bin/sh

YUM_CMD=$(which yum)
APT_GET_CMD=$(which apt-get)
DNF_CMD=$(which dnf)

 if [ ! -z $APT_GET_CMD ]; then
    sudo apt-get update
    sudo apt-get install git
 elif [ ! -z $DNF_CMD ]; then
    sudo dnf install git
 elif [ ! -z $YUM_CMD ]; then
    sudo yum install git
 else
    echo "error can't install package"
    exit 1;
 fi

git --version
