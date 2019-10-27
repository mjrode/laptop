#!/bin/bash
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $CURRENT_DIR/../../util/helper_functions
`scp preproduction.malauzai.com:/websites/sami/config/app_config.yml $CURRENT_DIR/../../install_files/app_config_preprod.yml`

if [ ! -f "$CURRENT_DIR/../../install_files/app_config_preprod.yml" ]; then
  fancy_echo "Unable to connect to preproduction"
  fancy_echo "Using default app_config.yml file which may be outdated and cause test failures"
  cp $CURRENT_DIR/../../install_files/app_config_default.yml $CURRENT_DIR/../../install_files/app_config.yml
else
  fancy_echo "Copying app_config.yml from preproduction"
  cp $CURRENT_DIR/../../install_files/app_config_preprod.yml $CURRENT_DIR/../../install_files/app_config.yml
fi