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

info "Downloading Helm"
$SUDO curl -sSL https://storage.googleapis.com/kubernetes-release/release/v1.13.3/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl
$SUDO chmod +x /usr/local/bin/kubectl

