#!/bin/sh

# Sublime Text 3 Install 
#
# No need to download this script, just run it on your terminal:
#
#     curl https://installer.to/sublimetext | bash


# Detect the architecture
if [[ "$(uname -m)" = "x86_64" ]]; then
  ARCHITECTURE="x64"
elif [[ "$(uname -m)" = "x86_32" ]]; then
 ARCHITECTURE="x32"
else
 echo "Architecture not detected"
fi


# Fetch the latest build version number 
BUILD=$(echo $(curl http://www.sublimetext.com/3) | sed -rn "s#.*The latest build is ([0-9]+)..*#\1#p")

URL="https://download.sublimetext.com/sublime_text_3_build_{$BUILD}_{$ARCHITECTURE}.tar.bz2"
INSTALLATION_DIR="/opt/sublime_text"


# Download the tarball, unpack and install
curl -o $HOME/st3.tar.bz2 $URL
if tar -xf $HOME/st3.tar.bz2 --directory=$HOME; then
  sudo mv $HOME/sublime_text_3 $INSTALLATION_DIR
  sudo ln -s $INSTALLATION_DIR/sublime_text /usr/local/bin/subl
fi
rm $HOME/st3.tar.bz2


# Add to applications list and set icon
sed 's/Icon=sublime-text/Icon=\/opt\/sublime_text\/Icon\/128x128\/sublime-text.png/g' > $HOME/.local/share/applications/sublime_text.desktop

echo '
Sublime Text 3 installed successfully!
Run with: subl
'
