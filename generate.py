import toml
import sys
import os
import logging
import errno

methods = {
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

def generate(path):

   installer_toml_path = path+"/installer.toml"
   installer_sh_path = path+"/installer.sh"

   installer_toml = open(installer_toml_path, "r")
   parsed_toml = toml.loads(installer_toml.read())
   try:
    with open(installer_sh_path, "w") as installer_sh:

      installer_sh.write("""#!/bin/sh
      
YUM_CMD=$(which yum) # yum package manager for RHEL & CentOS
DNF_CMD=$(which dnf) # dnf package manager for new RHEL & CentOS
APT_GET_CMD=$(which apt-get) # apt package manager for Ubuntu & other Debian based distributions
PACMAN_CMD=$(which pacman) # pacman package manager for ArchLinux
APK_CMD=$(which apk) # apk package manager for Alpine
GIT_CMD=$(which git) # to build from source pulling from git

""")

      seperator = "if"

      for section in parsed_toml:
         lines = parsed_toml[section]['sh']
         installer_sh.write(seperator+" "+get_method_case(section))
         for line in lines.split("\n"):
            installer_sh.write("   "+line+"\n")
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
