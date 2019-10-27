#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $DIR/../util/helper_functions
source $DIR/../script_config


if echo `git credential-osxkeychain | grep -q osxkeychain`; then
  fancy_echo "git credential-osxkeychain already installed"
else
  fancy_echo "Installing git credential-osxkeychain"
  curl -s -O http://github-media-downloads.s3.amazonaws.com/osx/git-credential-osxkeychain
  chmod u+x git-credential-osxkeychain
  git config --global credential.helper osxkeychain
fi

if echo $(git config --global email.name | grep `whoami`) > /dev/null;then
  fancy_echo "Git credentials have already been set:"
else
  fancy_echo "Setting git username to `whoami`"
  fancy_echo "Setting git email to ${email}"
  git config --global user.name `whoami`
  git config --global user.email $email
fi