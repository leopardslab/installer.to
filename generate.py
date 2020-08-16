import toml
import sys
import os
import logging
import errno
import pytablewriter
import re

methods = {
    "curl": "$CURL",
    "apt": "$APT_GET",
    "yum": "$YUM",
    "dnf": "$DNF",
    "apk": "$APK",
    "pacman": "$PACMAN",
    "git": "$GIT"
}

def update_readme(summary):
    writer = pytablewriter.MarkdownTableWriter()
    writer.headers = ["Tool", "Apt", "Yum", "Packman", "APK", "DNF", "CURL", "URL"]
    value_matrix = []
    for tool_shortname in summary:
        tool = summary[tool_shortname]
        name = tool['name']
        installers = tool['installers']
        apt = "Yes" if "apt" in installers else "No"
        yum = "Yes" if "yum" in installers else "No"
        pacman = "Yes" if "pacman" in installers else "No"
        apk = "Yes" if "apk" in installers else "No"
        dnf = "Yes" if "dnf" in installers else "No"
        curl = "Yes" if "curl" in installers else "No"
        url = "https://installer.to/" + tool_shortname
        value_matrix.append([name, apt, yum, pacman, apk, dnf, curl, url])

    writer.value_matrix = value_matrix
    table_md = writer.dumps()
    try:
        with open("./README.md", "r+") as readme_md:
            readme = readme_md.read()
            beggining = "<!-- beginning of tools list -->"
            end = "<!-- end of tools list -->"
            regex = r"" + beggining + "\n(.*)\n" + end
            readme = re.sub(regex, beggining + "\n" + table_md + "\n" + end, readme, flags=re.S)
            readme_md.seek(0)  # sets  point at the beginning of the file
            readme_md.truncate()  # Clear previous content
            readme_md.write(readme)
            readme_md.close()
    except Error as e:
        logging.error('Error occurred when trying to update README.md, error: ' + e)


def update_summary(name, shortname, description, installers):
    try:
        with open("./installers.toml", "r+") as installer_summary:
            summaary = installer_summary.read()
            parsed_summary_toml = toml.loads(summaary)
            if shortname not in parsed_summary_toml:
                parsed_summary_toml[shortname] = {}
            parsed_summary_toml[shortname]['name'] = name
            parsed_summary_toml[shortname]['name'] = name
            parsed_summary_toml[shortname]['description'] = description
            parsed_summary_toml[shortname]['installers'] = ",".join(installers)
            installer_summary.seek(0)  # sets  point at the beginning of the file
            installer_summary.truncate()  # Clear previous content
            installer_summary.write(toml.dumps(parsed_summary_toml))
            installer_summary.close()

            update_readme(parsed_summary_toml)
    except IOError as e:
        logging.error('Error occurred when trying to update installers.toml, error: ' + e)

def get_method_case(method):
    if method in methods:
        return "[ ! -z " + methods[method] + "_CMD ]; then\n"
    else:
        logging.error('Unpupported method in the TOML file, method: ' + method)
        exit(1)


def parse_line(line):
    line = line \
        .replace('@sudo', '$SUDO') \
        .replace('@log', 'info') \
        .replace('@info', 'info') \
        .replace('@warn', 'warn') \
        .replace('@error', 'error')
    return line


def write_sniffer_commands(sh_file):
    sh_file.write("""
CURL_CMD=$(which curl) 
YUM_CMD=$(which yum) 
DNF_CMD=$(which dnf) 
APT_GET_CMD=$(which apt-get) 
PACMAN_CMD=$(which pacman) 
APK_CMD=$(which apk) 
GIT_CMD=$(which git) 
""")


def write_sudo_fix_commands(sh_file):
    sh_file.write("""
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
""")


def write_logger_commands(sh_file):
    sh_file.write("""
RESET='\033[0m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
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


def write_installer_commands(sh_file, lines, indent=""):
    for line in lines.split("\n"):
        step = parse_line(line)
        sh_file.write(indent + step + "\n")

def generate_individual_installers(method, lines):
    installer_sh_path = path + "/installer."+method+".sh"
    try:
        with open(installer_sh_path, "w") as installer_sh:
            installer_sh.write("""#!/bin/sh
""")
            write_sudo_fix_commands(installer_sh)
            write_logger_commands(installer_sh)
            write_installer_commands(installer_sh, lines)

    except IOError as x:
        if x.errno == errno.EACCES:
            logging.error('No enough permissions to write to ' + installer_sh_path)
            exit(1)
        else:
            logging.error('Something went wrong when trying to write to ' + installer_sh_path, x)
            exit(1)

def generate(path):
    installer_methods = []
    installer_toml_path = path + "/installer.toml"
    installer_sh_path = path + "/installer.sh"

    installer_toml = open(installer_toml_path, "r")
    parsed_toml = toml.loads(installer_toml.read())
    try:
        with open(installer_sh_path, "w") as installer_sh:

            installer_sh.write("""#!/bin/sh
      
""")
            write_sniffer_commands(installer_sh)
            write_sudo_fix_commands(installer_sh)
            write_logger_commands(installer_sh)

            seperator = "if"

            for section in parsed_toml:
                if not isinstance(parsed_toml[section], dict):
                    continue
                if parsed_toml[section]['sh'] is "":
                    continue
                installer_methods.append(section)
                lines = parsed_toml[section]['sh']
                installer_sh.write(seperator + " " + get_method_case(section))
                write_installer_commands(installer_sh, lines, "   ")
                generate_individual_installers(section, lines)
                seperator = "elif"

            installer_sh.write("""
else
   echo "Couldn't install package"
   exit 1;
fi
              """.strip())

        installer_sh.close()
        update_summary(parsed_toml['name'], parsed_toml['shortname'], parsed_toml['description'], installer_methods)

    except IOError as x:
        if x.errno == errno.EACCES:
            logging.error('No enough permissions to write to ' + installer_sh_path)
            exit(1)
        else:
            logging.error('Something went wrong when trying to write to ' + installer_sh_path, x)
            exit(1)

for path in sys.argv[1:]:
    if os.path.exists(path + '/installer.toml'):
        logging.info('Generating installer.sh for ' + path)
        generate(path)
    else:
        logging.warn('Could not find an installer.toml in ' + path)
