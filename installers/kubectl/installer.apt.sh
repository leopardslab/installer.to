#!/bin/sh

SUDO_CMD=$(which sudo) 

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

RESET='[0m'
RED='[0;31m'
GREEN='[0;32m'
YELLOW='[0;33m'
log () {
 echo "[`date "+%Y.%m.%d-%H:%M:%S%Z"`]$1 $2"
}
info () {
 log "$GREEN INFO$RESET $1"
}
warn () {
 log "$YELLOW WARN$RESET $1"
}
error () {
 log "$RED ERROR$RESET $1"
}

$SUDO apt-get update && $SUDO apt-get install -y apt-transport-https gnupg2
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | $SUDO apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | $SUDO tee -a /etc/apt/sources.list.d/kubernetes.list
$SUDO apt-get update
$SUDO apt-get install kubectl

