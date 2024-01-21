#!/bin/bash

# Directorio de origen que deseas respaldar
export archivo_origen="src/respaldo_folder/test.txt"

# Nombre del archivo de copia de seguridad con marca de tiempo
export nombre_archivo_destino="respaldo_$(date +\%Y\%m\%d_\%H\%M\%S).tar.gz"
export archivo_destino="src/respaldo_folder/$nombre_archivo_destino"

# Comprimir y copiar los archivos de origen al directorio de destino
tar -czvf "$archivo_destino" "$archivo_origen"

python transfer_files.py