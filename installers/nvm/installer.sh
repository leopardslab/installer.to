#!/bin/bash

# nvm is not available as a distro package, installing manually from git to ~/.nvm

# install git - required dependency
if [ ! -f $(which git) ]; then
  curl https://installer.to/git | bash
fi

# https://github.com/nvm-sh/nvm#git-install
cd ~
git clone https://github.com/nvm-sh/nvm.git .nvm
cd ~/.nvm
# checkout latest github release
git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)`

cd ~
for FILE in .bashrc .zshrc .profile
do
  # if file exists and doesn't already have "NVM_DIR" inside
  if [[ -f $FILE && -z $(cat $FILE | grep NVM_DIR) ]]; then
    # to make nvm accessible on new terminal windows and after a reboot
    echo '
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion' >> $FILE
  fi
done

# to make nvm accessible right after installing
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
