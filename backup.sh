#!/bin/bash

# Directorio de origen que deseas respaldar
origen="/home/kali/Downloads"

# Directorio de destino donde se almacenarán las copias de seguridad
destino="/backups"
DESTINATION="drive2:backups"

# Nombre del archivo de copia de seguridad con marca de tiempo
archivo_destino="$destino/respaldo_$(date +\%Y\%m\%d_\%H\%M\%S).tar.gz"

# Comprimir y copiar los archivos de origen al directorio de destino
tar -czvf "$archivo_destino" "$origen"

# Subir a Google Drive usando gdrive
rclone sync "$destino" "$DESTINATION" --config="/home/kali/.config/rclone/rclone.conf"


# Comprobar si la copia de seguridad se realizó con éxito
if [ $? -eq 0 ]; then
  echo "Copia de seguridad exitosa en $archivo_destino"
else
  echo "Error al realizar la copia de seguridad."
fi
