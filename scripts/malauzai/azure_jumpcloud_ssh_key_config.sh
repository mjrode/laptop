DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $DIR/../../util/helper_functions
source $DIR/../../script_config

if [ "$1" = "no_open" ]; then
  open_urls=false
else
  open_urls=true
fi

### ADD OPTION TO SKIP ON RE RUN
fancy_echo "SSH key has been added to your clipboard."
pbcopy < ~/.ssh/id_rsa.pub


fancy_echo "Opening dev.azure.com, please ensure you are logged in before continuing."
if $open_urls; then
  message_user 'If you have logged in to dev.azure.com successfully enter: y'
  open 'https://dev.azure.com/Malauzai/_usersSettings/keys'
  while [ 1 ]
  do
    read answer
    if [ $answer == y -o $answer == Y ]; then
      break
    else
      message_user "Please log in first."
    fi
  done
else
  message_user 'Open https://dev.azure.com/Malauzai/_usersSettings/keys in your browser'
fi

message_user "Paste the ssh key that is already copied to your clipboard into the key field. \\nDo not alter the key \\nSet the title to jumpcloud_id_rsa\\nclick add key"

if $open_urls; then
  message_user 'When you are done enter: y'
  open 'https://dev.azure.com/Malauzai/_usersSettings/keys'
  while [ 1 ]
  do
    read answer
    if [ $answer == y -o $answer == Y ]; then
      break
    fi
  done
else
  message_user 'Open https://dev.azure.com/Malauzai/_usersSettings/keys in your browswer'
fi

pbcopy < ~/.ssh/id_rsa.pub




message_user "You will also need to configure this same key for Jumpcloud....\\n opening https://console.jumpcloud.com \\n please ensure you are logged in before continuing."


message_user "Paste the ssh key that is already copied to your clipboard into the key field. \\nDo not alter the key \\nSet the title to ssh-rsa\\nclick add save\\n"

if $open_urls; then
  open 'https://console.jumpcloud.com'
  message_user 'If you have logged in to jumpcloud successfully enter: y'
  while [ 1 ]
  do
    read answer
    if [ $answer == y -o $answer == Y ]; then
      break
    else
      message_user "Please log in first."
    fi
  done
else
  message_user 'Open https://console.jumpcloud.com in your browswer'
fi



fancy_echo 'SSH key setup complete!'