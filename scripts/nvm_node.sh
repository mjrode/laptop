#!/bin/sh
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $DIR/../util/helper_functions
source $DIR/../script_config

export NVM_DIR="$HOME/.nvm"
append_to_bash_profile '[[ -s $HOME/.nvm/nvm.sh ]] && . $HOME/.nvm/nvm.sh  # This loads NVM'
[[ -s $HOME/.nvm/nvm.sh ]] && . $HOME/.nvm/nvm.sh  # This loads NVM

if brew list nvm > /dev/null; then
  echo "NVM is already installed"
else
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.0/install.sh | bash
fi

nvm alias default $NODE_VERSION
nvm use $NODE_VERSION
if nvm ls | grep $NODE_VERSION; then
  echo "Node version $NODE_VERSION already installed"
else
  nvm install $NODE_VERSION
fi
