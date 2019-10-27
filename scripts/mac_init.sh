#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $DIR/../util/helper_functions
source $DIR/../script_config

# Welcome to the malauzai laptop setup script!
fancy_echo "Starting laptop setup script"

# Create .bin directory if it does not exist
if [ ! -d "$HOME/.bin/" ]; then
  fancy_echo "Creating ${HOME/.bin}"
  mkdir "$HOME/.bin"
fi

# Create .bash_profile if it does not exist
if [ ! -f "$HOME/.bash_profile" ]; then
  fancy_echo "Creating ${HOME/.bash_profile}"
  touch "$HOME/.bash_profile"
fi

# shellcheck disable=SC2016
# Add bin directory to your PATH and store in bash profile
append_to_bash_profile 'export PATH="$HOME/.bin:$PATH"'
append_to_bash_profile 'export PATH="/usr/local/sbin:$PATH"'

# Create homebrew directory if it does not exist
# Change ownership to current user or admin group
HOMEBREW_PREFIX="/usr/local"
if [ -d "$HOMEBREW_PREFIX" ]; then
  if ! [ -r "$HOMEBREW_PREFIX" ]; then
    sudo chown -R "$LOGNAME:admin" /usr/local
  fi
else
  sudo mkdir "$HOMEBREW_PREFIX"
  sudo chflags norestricted "$HOMEBREW_PREFIX"
  sudo chown -R "$LOGNAME:admin" "$HOMEBREW_PREFIX"
fi

if ! command -v brew >/dev/null; then
  fancy_echo "Installing Homebrew ..."
    curl -fsS \
      'https://raw.githubusercontent.com/Homebrew/install/master/install' | ruby
fi

append_to_bash_profile "# recommended by brew doctor"
append_to_bash_profile 'export PATH="/usr/local/bin:$PATH"' 1
append_to_bash_profile 'export PATH="/usr/local/opt/libxml2/bin:$PATH"' 1
export PATH="/usr/local/bin:$PATH"

# remove old version of brew cask if found
if brew list | grep -Fq brew-cask; then
  fancy_echo "Uninstalling old Homebrew-Cask ..."
  brew uninstall --force brew-cask
fi

if [ ! "$1" = "skip_brew" ]; then
  fancy_echo "Updating Homebrew formulae ..."
  brew update --force # https://github.com/Homebrew/brew/issues/1151
  brew tap "homebrew/services"
else
  fancy_echo "Skipping brew update"
fi

brew list "git" > /dev/null || brew install "git"
brew list "openssl" > /dev/null || brew install "openssl"
brew list "readline" > /dev/null || brew install "readline"
brew list "libxml2" > /dev/null || brew install "libxml2"
brew list "imagemagick" > /dev/null || brew install "imagemagick"
brew list "libyaml" > /dev/null || brew install "libyaml"
brew list "coreutils" > /dev/null || brew install "coreutils"
brew list "gnupg" > /dev/null || brew install "gnupg"
brew list "postgresql@$POSTGRES_VERSION" > /dev/null || brew install "postgresql@$POSTGRES_VERSION", restart_service: :changed
brew list "redis" > /dev/null || brew install "redis", restart_service: :changed

if [ ! -f /Library/Developer/CommandLineTools/Packages/macOS_SDK_headers_for_macOS_10.14.pkg ]; then
  fancy_echo "Install Xcode command line tool headers"
  sudo installer -pkg /Library/Developer/CommandLineTools/Packages/macOS_SDK_headers_for_macOS_10.14.pkg -target /
fi

fancy_echo "Mac setup script was SUCCESSFUL"
