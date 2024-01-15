#!/bin/bash

#Descomentar la siguiente linea para debug!
#set -x 

#Parametros configurables:
#Base de datos:
DB_USER="username"
DB_PASS="user-password"
DB_DATABASE="dbname"

#Archivo Backup
SUFIX=$(date +%Y%m$d_%H%M%S)
PREFIX="trabajo_db_bkp"
LOCALPATH="/srv/MysqlBackups/"
FILE=${LOCALPATH}${PREFIX}${SUFIX}".sql"
FILE_MD5=${FILE}".gz.md5sum"

#Servidor remoto SCP
#Se debe usar ssh-key sin password
REMOTE_SERVER="localhost"
REMOTE_USER="remoteuser"
REMOTE_PATH="/srv/Backups"

#Backup Mysql
mysqldump --user ${DB_USER} --password=${DB_PASS} ${DB_DATABASE} >${FILE}
if [ $? -ne 0 ]; then
  echo "Error mysqldump ¿problemas de permisos de usuario?"
  exit 1
fi

#Compresion y chequeo de integridad
gzip -9 ${FILE}
if [ $? -ne 0 ]; then
  echo "Error gzip ¿problemas de espacio en disco?"
  exit 1
fi

md5sum ${FILE}".gz">${FILE_MD5}
if [ $? -ne 0 ]; then
  echo "Error md5sum ¿ wtf ?"
  exit 1
fi

# Destino SCP
scp ${FILE}.* "${REMOTE_USER}@${REMOTE_SERVER}:${REMOTE_PATH}"
if [ $? -ne 0 ]; then
  echo "Error scp ¿problemas de login remoto?¿Servidor apagado?"
  exit 1
fi

echo "Copia de seguridad exitosa!!"
