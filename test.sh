#!/bin/bash

# Directorio de origen que deseas respaldar
source="/home/s4int/Documents/Backup-Utility"
# Directorio de destino (local) 
local_dest="/Backups/Backup-Utility"
# Directorio de destino (cloud) Usando RClone
remote_dest="gdrive:/Backups/GDrive"

# Nombre del archivo de copia de seguridad con marca de tiempo
archivo_destino="$local_dest/respaldo_$(date +\%Y\%m\%d_\%H\%M\%S).tar.gz"

# Comprimir y copiar los archivos de origen al directorio local
tar -czvf "$archivo_destino" "$source"

# Comprobar si la operación de compresión y copia fue exitosa
if [ $? -eq 0 ]; then
    echo "Copia de seguridad local exitosa en $archivo_destino"
else
    echo "Error al realizar la copia de seguridad local."
    exit 1  # Salir del script si hay un error
fi

# Sincronizar el directorio local con el directorio cloud usando RClone
rclone sync "$local_dest" "$remote_dest" --config="/home/s4int/.config/rclone/rclone.conf"

# Comprobar si la sincronización con el cloud fue exitosa
if [ $? -eq 0 ]; then
    echo "Sincronización con el cloud exitosa."
else
    echo "Error al sincronizar con el cloud."
    exit 1  # Salir del script si hay un error
fi

# Mensaje de éxito
echo "¡La copia de seguridad y sincronización se han realizado correctamente!"