#!/bin/bash

# Directorio que quieres respaldar
origen="files"

# Directorio destino para guardas las copias
destino="backup_files"

# Nombre del archivo de copia de seguridad
archivo_destino="$destino/respaldo_$(date +\%Y\%m\%d_\%H\%M\%S).tar.gz"

clear
echo -e "Iniciando copia de seguridad...\n"

# Comprimir respaldo
tar -czvf "$archivo_destino" "$origen"

# Comprobar si la copia de seguridad se realizó con éxito
if [ $? -eq 0 ]
then
	echo -e "\nCopia de seguridad exitosa en $archivo_destino"
else
	echo -e "\nError al realizar la copia de seguridad."
fi

