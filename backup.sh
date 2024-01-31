#!/bin/bash

# SERVERS AND DIRECTORY PATHS
SOURCE_DIRECTORY="/home/user/web_server"
DESTINATION_SERVER="user@ipaddress"
DESTINATION_DIRECTORY="/home/destination_user"

# COMPRESSED DIRECTORY NAME WITH TIMESTAMP
COMPRESSED_FILE="backup_server_$(date +\%Y\%m\%d_\%H\%M\%S).tar.gz"

# COMPRESS THE DIRECTORY USING TAR
tar --ignore-failed-read -czvf "$COMPRESSED_FILE" "$SOURCE_DYRECTORY"

# VERIFYING TAR OUTPUT
if [ $? -eq 0 ]; then
  # COPYING THE COMPRESSED DIRECTORY TO THE DESTINATION SERVER
  scp -r -i  ~/.ssh/keyfile "$COMPRESSED_FILE" "$DESTINATION_SERVER:$DESTINATION_DIRECTORY"

  # VERIFYING SCP OUTPUT
  if [ $? -eq 0 ]; then
    echo "The Backup was successfully completed."
  else
    echo "Error copying the directory to the destination server."
  fi

  # REMOVE THE LOCALLY COMPRESSED DIRECTORY
  rm "$COMPRESSED_FILE"
else
  echo "Error compressing the directory"
fi