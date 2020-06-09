import toml
import sys

methods = {
   "apt": "$APT_GET",
   "yum": "$YUM",
   "dnf": "$DNF",
   "apk": "$APK",
   "pacman": "$PACMAN"
}

def get_method_case(method):
   return "[ ! -z "+methods[method]+"_CMD ]; then\n"

for path in sys.argv[1:]:

   installer_toml_path = path+"/installer.toml"
   installer_sh_path = path+"/installer.sh"

   installer_toml = open(installer_toml_path, "r")
   parsed_toml = toml.loads(installer_toml.read())

   installer_sh = open(installer_sh_path, "w")

   installer_sh.write("""#!/bin/sh
   
   YUM_CMD=$(which yum) # yum package manager for RHEL & CentOS
   DNF_CMD=$(which dnf) # dnf package manager for new RHEL & CentOS
   APT_GET_CMD=$(which apt-get) # apt package manager for Ubuntu & other Debian based distributions
   PACMAN_CMD=$(which pacman) # pacman package manager for ArchLinux
   APK_CMD=$(which apk) # apk package manager for Alpine
   
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
