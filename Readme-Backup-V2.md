# Documentacion Backup Version 2

Este documento provee una breve guía para el correcto uso del utilitario **backup-utility-V2.sh**.

La funcionalidad del script es realizar backups de base de datos MYSQL y subirlo por protocolo SSH a un servidor remoto.

El scrip se divide en 3 partes bien diferenciadas. Cada parte se ocupa de realizar una tarea especifica (UNIX!).

La configuración se realiza cambiando los parámetros específicos de cada etapa:

```bash
#!/bin/bash

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
REMOTE_USER="user"
REMOTE_PATH="/srv/Backups"
```

## Base de datos

Se supone que la base de datos es Mysql, que además está instalado la utilidad **mysqldump** y que el servidor está es en *localhost*.

El comando a utilizar es **mysqldump**. 

Si falla la  ejecución es tipicamente debido a las credenciales incorrectas para ingresar.

```bash
mysqldump --user ${DB_USER} --password=${DB_PASS} ${DB_DATABASE} >${FILE}
if [ $? -ne 0 ]; then
  echo "Error mysqldump ¿problemas de permisos de usuario?"
  exit 1
fi
```

En caso de que la base de datos esté en otro servidor se debe agregar la opcion **-h IPSERVIDOR** al comando mysqldump.

Si la base es Postgres se puede reemplazar el comando por **pg_dump** con sintaxis muy similar al mysqldump.

## Compresión y chequeo de integridad

Luego de haber generado un archivo de texto con comandos SQL, falta comprimirlo con la utilidad de linux **gzip**. Finalmente se genera un archivo md5sum que acompañara al backup de la base de datos al servidor destino de backup.

```bash
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
```

## Copia a servidor remoto

La forma segura de dejar subir archivos a un servidor remoto (Local Network o Cloud) es utilizando el protocolo SSH.

El protocolo ssh requiere usuario y password para acceso, sin embargo existe una manera cómoda de credenciales que es creando un par de claves **ssh public key**  (RTFM: Google). Esto evita tener que guarda la contraseña en el mismo script (security red flag!!).

La copia de archivos mediante el protocolo SSH se realiza a través de una utilidad llamada **scp**.

```bash
scp ${FILE}.* "${REMOTE_USER}@${REMOTE_SERVER}:${REMOTE_PATH}"
if [ $? -ne 0 ]; then
  echo "Error scp ¿problemas de login remoto?¿Servidor apagado?"
  exit 1
fi
```


## Automatización

Una vez configurado correctamente todos los parmetros y habiendo probado la ejecución exitosa del script se procede a dejarlo en el crontab de linux:

```
0 2 * * * /path/to/backup/script.sh
```


## Debug

Se puede habilitar la opcion **set -x** al inicio del script para verificar cada paso de su ejecución.

```bash
  $ ./backup-utility-V2.sh                                 
    + DB_USER=username                                                      
    + DB_PASS=user-password          
    + DB_DATABASE=dbname                                                    
    ++ date +%Y%m%H%M%S              
    + SUFIX=202401161800                                                    
    + PREFIX=trabajo_db_bkp          
    + LOCALPATH=/srv/MysqlBackups/                                          
    + FILE=/srv/MysqlBackups/trabajo_db_bkp202401161800.sql
    + FILE_MD5=/srv/MysqlBackups/trabajo_db_bkp202401161800.sql.gz.md5sum
    + REMOTE_SERVER=localhost        
    + REMOTE_USER=username                                                     
    + REMOTE_PATH=/srv/Backups       
    + mysqldump --user username --password=user-password dbname
    + '[' 0 -ne 0 ']'                   
    + gzip -9 /srv/MysqlBackups/trabajo_db_bkp202401161800.sql
    + '[' 0 -ne 0 ']'                   
    + md5sum /srv/MysqlBackups/trabajo_db_bkp202401161800.sql.gz
    + '[' 0 -ne 0 ']'                   
    + scp /srv/MysqlBackups/trabajo_db_bkp202401161800.sql.gz /srv/MysqlBackups/trabajo_db_bkp202401161800.sql.gz.md5sum usuario@localhost:/srv/Backups
    trabajo_db_bkp202401161800.sql.gz     100%  496     1.0MB/s   00:00    
    trabajo_db_bkp202401161800.sql.gz.md5 100%   86   274.0KB/s   00:00    
    + '[' 0 -ne 0 ']'                   
    + echo 'Copia de seguridad exitosa!!'
    Copia de seguridad exitosa!!
      
```

