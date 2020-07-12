import toml
import sys
import os
import logging
import errno

methods = {
   "curl": "$CURL",
   "apt": "$APT_GET",
   "yum": "$YUM",
   "dnf": "$DNF",
   "apk": "$APK",
   "pacman": "$PACMAN",
   "git": "$GIT"
}

def get_method_case(method):
   if method in methods:
      return "[ ! -z "+methods[method]+"_CMD ]; then\n"
   else:
      logging.error('Unpupported method in the TOML file, method: '+method)
      exit(1)

def parse_line(line):
    line = line\
        .replace('@sudo', '$SUDO')\
        .replace('@log', 'info')\
        .replace('@info', 'info')\
        .replace('@warn', 'warn')\
        .replace('@error', 'error')
    return line

def generate(path):

   installer_toml_path = path+"/installer.toml"
   installer_sh_path = path+"/installer.sh"

   installer_toml = open(installer_toml_path, "r")
   parsed_toml = toml.loads(installer_toml.read())
   try:
    with open(installer_sh_path, "w") as installer_sh:

      installer_sh.write("""#!/bin/sh
      
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

RESET='\033[0m'          # Red
RED='\033[0;31m'          # Red
GREEN='\033[0;32m'        # Green
YELLOW='\033[0;33m'      # Yellow
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

""")

      seperator = "if"

      for section in parsed_toml:
         lines = parsed_toml[section]['sh']
         installer_sh.write(seperator+" "+get_method_case(section))
         for line in lines.split("\n"):
             step = parse_line(line)
             installer_sh.write("   "+step+"\n")
         seperator = "elif"

      installer_sh.write("""
else
   echo "Couldn't install package"
   exit 1;
fi
      """.strip())

      installer_sh.close()

   except IOError as x:
      if x.errno == errno.EACCES:
         logging.error('No enough permissions to write to '+installer_sh_path)
         exit(1)
      else:
         logging.error('Something went wrong when trying to write to '+installer_sh_path)
         exit(1)

for path in sys.argv[1:]:
   if os.path.exists(path+'/installer.toml'):
         logging.info('Generating installer.sh for '+path)
         generate(path)
   else:
         logging.warn('Could not find an installer.toml in '+path)
