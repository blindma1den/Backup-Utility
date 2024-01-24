#!/bin/bash

# SERVERS AND DIRECTORY PATHS
SOURCE_DIRECTORY="/home/jnitoal/web_server"
DESTINATION_SERVER="codevars@192.168.0.107"
DESTINATION_DIRECTORY="/home/codevars/"

# COMPRESSED DIRECTORY NAME WITH TIMESTAMP
COMPRESSED_FILE="backup_server_$(date +\%Y\%m\%d_\%H\%M\%S).tar.gz"

# COMPRESS THE DIRECTORY USING TAR
tar --ignore-failed-read -czvf "$COMPRESSED_FILE" "$SOURCE_DYRECTORY"

# VERIFYING TAR OUTPUT
if [ $? -eq 0 ]; then
  # COPYING THE COMPRESSED DIRECTORY TO THE DESTINATION SERVER
  scp -r -i  ~/.ssh/id_rsa "$COMPRESSED_FILE" "$DESTINATION_SERVER:$DESTINATION_DIRECTORY"

  # VERIFYING SCP OUTPUT
  if [ $? -eq 0 ]; then
    echo "El respaldo se realizó exitosamente."
  else
    echo "Error al copiar el archivo comprimido al servidor de destino."
  fi

  # REMOVE THE LOCALLY COMPRESSED DIRECTORY
  rm "$COMPRESSED_FILE"
else
  echo "Error al comprimir el archivo."
fi