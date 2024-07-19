#!/bin/bash

# Check if the number of arguments is correct
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <environment>"
  exit 1
fi

ENVIRONMENT="$1"
CONFIG_FILE="$HOME/.ssh-mirror-config.json"

# Check if the config.json file exists
if [[ ! -f "$CONFIG_FILE" ]]; then
  echo "File "~/.ssh-mirror-config.json" not found!"
  exit 1
fi

# Read configurations from config.json using jq
USER=$(jq -r ".$ENVIRONMENT.credentials.user" "$CONFIG_FILE")
PORT=$(jq -r ".$ENVIRONMENT.credentials.port" "$CONFIG_FILE")
HOST=$(jq -r ".$ENVIRONMENT.credentials.host" "$CONFIG_FILE")
KEY_PATH=$(jq -r ".$ENVIRONMENT.credentials.key_path" "$CONFIG_FILE")
PORTS=$(jq -r ".$ENVIRONMENT.ports[]" "$CONFIG_FILE")

# Construct the ssh command with port forwarding
SSH_COMMAND="ssh -N"

# Check if key_path is defined and add to SSH connection
if [[ -n "$KEY_PATH" ]]; then
  SSH_COMMAND="$SSH_COMMAND -i $KEY_PATH"
fi

# Add port forwarding
for LINE in $PORTS; do
  LOCAL_PORT=$(echo "$LINE" | cut -d':' -f1)
  REMOTE_PORT=$(echo "$LINE" | cut -d':' -f2)
  SSH_COMMAND="$SSH_COMMAND -L $LOCAL_PORT:$HOST:$REMOTE_PORT"
done

SSH_COMMAND="$SSH_COMMAND -p $PORT $USER@$HOST"

# Print connection message and forwarded ports
echo -e "\e[1mConnecting to server \e[1;36m$USER@$HOST\e[0m\e[0m\n"
echo -e "\e[1mForwarded ports <local:server>:\e[0m"
echo "$PORTS" | while IFS= read -r line; do echo -e "\e[1;36m$line\e[0m"; done
echo -e "\n$SSH_COMMAND"

eval "$SSH_COMMAND"
