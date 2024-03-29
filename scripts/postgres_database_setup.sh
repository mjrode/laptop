#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $DIR/../util/helper_functions
source $DIR/../script_config

# sym_link=/Users/mike.rode/Library/LaunchAgents/homebrew.mxcl.postgresql.plist
if [ ! -f "$sym_link" ]; then
  fancy_echo "Creating symlink to run postgres at startup"
  ln -sfv /usr/local/opt/postgresql/*.plist ~/Library/LaunchAgents
fi

fancy_echo "Creating aliases to start and stop postgres: pg_start, pg_stop"
append_to_bash_profile `alias pg_start="launchctl load ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist"`
append_to_bash_profile `alias pg_stop="launchctl unload ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist"`


if launchctl list | grep homebrew.mxcl.postgresql >/dev/null; then
  fancy_echo "postgres is already running"
else
  fancy_echo "starting postgresql"
  launchctl load ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist
fi

if ! psql -c '\du' | awk '{print $1}' | grep -q `whoami`; then
  fancy_echo "Creating db `whoami`"
  createdb `whoami`
fi

if psql -c '\du' | awk '{print $1}' | grep -q postgres; then
  fancy_echo "Postgres user already exists"
else
  fancy_echo "Creating default postgres user"
  createuser -s postgres
fi
