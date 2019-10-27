#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $DIR/../util/helper_functions
source $DIR/../script_config

read -r -d '' RT <<- "EOM"
  rt() {
    RAILS_ENV=test
    if [ -z "$1" ];then
      RAILS_ENV=test RUBYOPT=W0 bundle exec rake test:controllers COVERAGE=true
    elif [ ! -z "$2" ]; then
      echo "Running single test: ${2}"
      RAILS_ENV=test bundle exec rake test TEST=$1 TESTOPTS=" -n /${2}/"
    else
      RAILS_ENV=test bundle exec rake test TEST=$1
    fi
  }
EOM

append_to_bash_profile "$RT"
append_to_bash_profile "bind 'set completion-ignore-case on'"
append_to_bash_profile 'alias bp="vim ~/.bash_profile"'
append_to_bash_profile 'alias sbp="source ~/.bash_profile"'
append_to_bash_profile "alias rake='bundle exec rake'"
append_to_bash_profile "alias ssha='ssh-add ~/.ssh/id_rsa'"
append_to_bash_profile 'export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"'
append_to_bash_profile 'export PATH="/usr/local/bin:$PATH"'