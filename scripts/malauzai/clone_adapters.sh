#!/bin/bash
source $DIR/../../util/helper_functions
source $DIR/../../script_config

if [ ! -d "$DEFAULT_DIRECTORY/" ]; then
  fancy_echo "Creating root directory: ${DEFAULT_DIRECTORY}"
  mkdir $DEFAULT_DIRECTORY
fi

cd $DEFAULT_DIRECTORY

if [ -d !adapters ]; then
  fancy_echo "Creating adapters directory"
  mkdir adapters
fi
cd adapters

repos=(
  "m1-alpha-omega-adapter"
  "m1-bottomline-oflows-sso-adapter"
  "m1-cohesion-adapter"
  "m1-cubus-adapter"
  "m1-datasafe-adapter"
  "m1-deluxe-services-adapter"
  "m1-horizon-adapter"
  "m1-identifi-adapter"
  "m1-ims-integration-adapter"
  "m1-ipay-adapter"
  "m1-iti-premier-adapter"
  "m1-mci-adapter"
  "m1-metavante-adapter"
  "m1-midwest-printing-adapter"
  "m1-monotto-adapter"
  "m1-myriad-adapter"
  "m1-phoenix-adapter"
  "m1-precision-adapter"
  "m1-summit-adapter"
  "cards-image-service"
  "database-service"
  "grand-central-service"
  "internal-p2p-service"
  "locations-service"
  "statement-fetching-service"
  "savings-rewards-service"
)
for repo in "${repos[@]}"
do
  if [ -d "${repo}" ]; then
    echo "Skipping ${repo}, it already exists."
  else
    echo "Attempting to clone ${repo}"
    git clone git@ssh.dev.azure.com:v3/Malauzai/Malauzai/$repo
  fi
done

cd $ROOT_DIR