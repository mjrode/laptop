DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $DIR/../../util/helper_functions
source $DIR/../../script_config
source $DIR/fetch_app_config.sh

# Pass custom_gem as first argument to only install malauzai custom gems. Helpful when switching ruby versions.
if [ "$1" = "custom_gem" ]; then
  if [ ! -z "$2" ]; then
  echo "cd $2"
    cd $2
  fi
  custom_gem=true
else
  custom_gem=false
fi

if $custom_gem; then
  # #1 = name 2 = git url  3 = gemspec 4 = gemname 5= name to check before install
  install_custom_malauzai_gem soap4r git@ssh.dev.azure.com:v3/Malauzai/Malauzai/soap4r malauzai-soap4r.gemspec malauzai-soap4r-2.0.5.gem malauzai-soap4r

  install_custom_malauzai_gem wkhtmltoimage-binary git@ssh.dev.azure.com:v3/Malauzai/Malauzai/wkhtmltoimage-binary wkhtmltoimage-binary.gemspec malauzai-wkhtmltoimage-binary-0.12.3.gem malauzai-wkhtmltoimage-binary

  install_custom_malauzai_gem wkhtmltopdf-binary git@ssh.dev.azure.com:v3/Malauzai/Malauzai/wkhtmltopdf-binary wkhtmltopdf-binary.gemspec malauzai-wkhtmltopdf-binary-0.12.3.gem malauzai-wkhtmltopdf-binary
else

  if [ ! -d "$DEFAULT_DIRECTORY/" ]; then
    fancy_echo "Creating root directory: ${DEFAULT_DIRECTORY}"
    mkdir $DEFAULT_DIRECTORY
  fi

  cd $DEFAULT_DIRECTORY


# #1 = name 2 = git url  3 = gemspec 4 = gemname 5= name to check before install
install_custom_malauzai_gem soap4r git@ssh.dev.azure.com:v3/Malauzai/Malauzai/soap4r malauzai-soap4r.gemspec malauzai-soap4r-2.0.5.gem malauzai-soap4r

install_custom_malauzai_gem wkhtmltoimage-binary git@ssh.dev.azure.com:v3/Malauzai/Malauzai/wkhtmltoimage-binary wkhtmltoimage-binary.gemspec malauzai-wkhtmltoimage-binary-0.12.3.gem malauzai-wkhtmltoimage-binary

install_custom_malauzai_gem wkhtmltopdf-binary git@ssh.dev.azure.com:v3/Malauzai/Malauzai/wkhtmltopdf-binary wkhtmltopdf-binary.gemspec malauzai-wkhtmltopdf-binary-0.12.3.gem malauzai-wkhtmltopdf-binary


  sami_repo="git@ssh.dev.azure.com:v3/Malauzai/Malauzai/sami"

  if [ ! -d "$DEFAULT_DIRECTORY/sami" ]; then
    fancy_echo "Cloning SAMI"
    git clone $sami_repo
  fi

  if [ ! -d "$DEFAULT_DIRECTORY/sami/log" ]; then
    mkdir $DEFAULT_DIRECTORY/sami/log
  fi


  sami_dir="$DEFAULT_DIRECTORY/sami"

  cd $sami_dir

  gem_install_or_update bundler -v $BUNDLER_VERSION
  bundle install


  if [ ! -f "$sami_dir/config/database.yml" ]; then
    fancy_echo "Creating database.yml file"
    cp $DIR/../../install_files/database.yml $sami_dir/config/
  fi

  if [ ! -f "$sami_dir/config/app_config.yml" ]; then
    fancy_echo "Creating app_config.yml file"
    cp $DIR/../../install_files/app_config.yml $sami_dir/config/
  fi
  # get list of certs from preprod
  ssh preproduction.malauzai.com ls -A  /websites/sami/config/certificates | cat > $DIR/../../install_files/certs

  certs=("${sami_dir}/config/certificates/*")

  while IFS= read -r filename; do
    if containsElement "${filename}" "${certs[@]}"; then
      continue
    fi
    if [ ! -f "$sami_dir/config/certificates/$filename" ]; then
      if  echo $filename | grep crt ; then
        fancy_echo "creating cert $filename"
        cp  $DIR/../../install_files/bob.crt  $sami_dir/config/certificates/$filename
      else
        fancy_echo "creating key $filename"
        cp  $DIR/../../install_files/bob.key  $sami_dir/config/certificates/$filename
      fi
    fi
  done < $DIR/../../install_files/certs


  if [ "$1" != 'skip_migrations' ]; then
    bundle exec rake db:drop
    bundle exec rake db:create
    # This works for citus
    # rake db:structure:load DB_STRUCTURE=db/citus_structure.sql
    psql -U postgres -d sami_development -1 -f $sami_dir/db/structure.sql

    bundle exec rake db:migrate
    bundle exec rake db:seed ADMIN_USER_LOGIN='admin' ADMIN_USER_PWD='KingKong20!' ALERT_SENDER_LOGIN='admin1' ALERT_SENDER_PWD='KingKong20!'
    bundle exec rake db:test:prepare
  fi
fi

fancy_echo "SAMI setup script finished"
cd $ROOT_DIR