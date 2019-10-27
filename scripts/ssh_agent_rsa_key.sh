#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $DIR/../util/helper_functions
source $DIR/../script_config

# The ssh-agent is a helper program that keeps track of user's identity keys and their passphrases. The agent can then use the keys to log into other servers without having the user type in a password or passphrase again. This implements a form of single sign-on (SSO).

if ls -al ~/.ssh  | grep id_rsa > /dev/null; then
  fancy_echo "found existing id_rsa key"
else
  fancy_echo "Creating id_rsa ssh key for ${$USER_EMAIL}"
  ssh-keygen -t rsa -C "$USER_EMAIL"
fi

if [ $(ps ax | grep [s]sh-agent | wc -l) -gt 0 ] ; then
    echo "ssh-agent is already running"
else
    eval $(ssh-agent -s)
    trap "ssh-agent -k" exit
fi

if ssh-add -l | grep id_rsa > /dev/null; then
  fancy_echo "Key already added to ssh-agent"
else
  fancy_echo "Adding id_rsa to ssh-agent"
  ssh-add ~/.ssh/id_rsa
fi
