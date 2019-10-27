#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $DIR/../../util/helper_functions
source $DIR/../../script_config

read -r -d '' VIMP <<- "EOM"
  # vim to preprod file
  vimp() {
    ssh -t preproduction.malauzai.com sudo su - mastermonkey -c cd /websites/sami && vim $1
  }
EOM

append_to_bash_profile "$VIMP"
append_to_bash_profile 'alias pp="ssh preproduction.malauzai.com"'
append_to_bash_profile "alias pl='$DEFAULT_DIRECTORY/sami/script/prod_logs/log_tail.sh'"