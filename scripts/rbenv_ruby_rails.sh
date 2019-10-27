#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $DIR/../util/helper_functions
source $DIR/../script_config


export PATH="/usr/local/opt/libxml2/bin:$PATH"

if ! which rbenv; then
  fancy_echo "Installing rbenv version manager ..."
  brew install rbenv ruby-build
fi

append_to_bash_profile 'if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi'

if rbenv versions  | grep $RUBY_VERSION -q > /dev/null; then
  fancy_echo "Ruby $RUBY_VERSION is already installed..."
else
  fancy_echo `Installing Ruby $($RUBY_VERSION)`
  RUBY_CONFIGURE_OPTS=--with-readline-dir="$(brew --prefix readline)" rbenv install $RUBY_VERSION
fi

if ! rbenv global | grep -q $RUBY_VERSION; then
  fancy_echo "Current Ruby version `ruby -v`"
  rbenv global $RUBY_VERSION
fi

if ! gem list | grep -q "rails.*$RAILS_VERSION"; then
  export PATH="/usr/local/opt/libxml2/bin:$PATH"
  # Might need to add install for x-code tools here to prevent error
  fancy_echo "Installing Rails $RAILS_VERSION"
  gem install rails -v $RAILS_VERSION
else
  fancy_echo "Rails $RAILS_VERSION is already installed..."
fi

if [ ! -d ~/.rbenv/plugins/rbenv-gem-rehash ]; then
  git clone https://github.com/sstephenson/rbenv-gem-rehash.git ~/.rbenv/plugins/rbenv-gem-rehash
  rbenv rehash
fi