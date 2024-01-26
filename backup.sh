#!/bin/bash

# Directorio de origen que deseas respaldar
origen="./Files"

# Directorio de destino donde se almacenarán las copias de seguridad
destino="./Backup_files"

#Destino donde se guardara en la nube mediante rclone
destino_nube="remote:Backup_files"

# Nombre del archivo de copia de seguridad con marca de tiempo
archivo_destino="$destino/respaldo_$(date +\%Y\%m\%d_\%H\%M\%S).tar.gz"

# Comprimir y copiar los archivos de origen al directorio de destino
tar -czvf "$archivo_destino" "$origen"

# Copia los archivos generados en el destino donde estan las copias de seguridad "archivo_destino" para ser enviados a Google Drive utilizando rclone
rclone copy "$archivo_destino" "$destino_nube"

# Comprobar si la copia de seguridad se realizó con éxito
if [ $? -eq 0 ]; then
  echo "Copia de seguridad exitosa en $archivo_destino"
else
  echo "Error al realizar la copia de seguridad."
fi
