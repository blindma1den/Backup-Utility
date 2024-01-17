#!/bin/sh

# Check if env variables are not emptys
if [ -z "$FTP_SERVER" ] || [ -z "$FTP_USERNAME" ] || [ -z "$FTP_PASSWORD" ]; then
    echo "Error: Las variables de entorno FTP_SERVER, FTP_USERNAME y FTP_PASSWORD deben establecerse."
    exit 1
fi

# Directorio de origen que deseas respaldar
SOURCEFILES="../backups"

# Directorio de destino donde se almacenarán las copias de seguridad (Remoto)
BACKUPDIRECTORY="/backupdir/"

# Nombre del archivo de copia de seguridad con marca de tiempo, incluye path remoto
BACKUPFILENAME="respaldo_$(date +\%Y\%m\%d_\%H\%M\%S).tar.gz"
REMOTEFILE="$BACKUPDIRECTORY$BACKUPFILENAME"

# Nombre y ruta del backup
LOCALFILE="$SOURCEFILES/$BACKUPFILENAME"

# Carpeta temporal para chequear los hash
CHECKSUM_DIR="./checksum"

# Funcion que calcula los md5 (la de canelon modificada)
calcular_md5sum() {
    local archivo="$1"
    local tamano_bloque=65536

    if [ -f "$archivo" ]; then
        md5sum=$(md5sum "$archivo" | cut -d' ' -f1)
        echo "$md5sum"
    else
        echo "Error: El archivo '$archivo' no se encontró."
        exit 1
    fi
}

# Comprimir y copiar los archivos de origen al directorio de destino
tar -czvf "$LOCALFILE" "$SOURCEFILES"

# Comprobar si la copia de seguridad se realizó con éxito
if [ $? -eq 0 ]; then
    echo "Copia de seguridad local exitosa en $LOCALFILE"

    # Subir los archivos a un servidor vía FTP (me cree uno gratis en infinityfree y usa TLS explícito sino da error)
    lftp -u "$FTP_USERNAME","$FTP_PASSWORD" "$FTP_SERVER" <<EOF
    set ftp:ssl-force true
    set ftp:ssl-protect-data true
    set ssl:verify-certificate no

    cd "$BACKUPDIRECTORY"
    put "$LOCALFILE" -o "$BACKUPFILENAME"
    quit
EOF

    # Chequear si se subió el archivo
    if [ $? -eq 0 ]; then
        echo "Copia de seguridad subida con éxito a $REMOTEFILE"

        # Descargamos el archivo y lo copiamos en una carpeta que usaremos de forma temporal
        # porque no me dejaba chequear el sum con lftp de forma remota
        mkdir -p "$CHECKSUM_DIR"
        lftp -u "$FTP_USERNAME","$FTP_PASSWORD" "$FTP_SERVER" <<EOF
        set ftp:ssl-force true
        set ftp:ssl-protect-data true
        set ssl:verify-certificate no

        cd "$BACKUPDIRECTORY"
        get "$BACKUPFILENAME" -o "$CHECKSUM_DIR/$BACKUPFILENAME"
        quit
EOF

        # Calcula el hash md5 del archivo local (original)
        local_md5=$(calcular_md5sum "$LOCALFILE")

        # Calculate MD5 del archivo que está subido en el FTP, pero desde la carpeta checksum
        remote_md5=$(calcular_md5sum "$CHECKSUM_DIR/$BACKUPFILENAME")

        # Mostramos los hashes
        echo "Hash MD5 local:   $local_md5"
        echo "Hash MD5 remoto:  $remote_md5"

        # Comparamos el local y el remoto y si son iguales eliminamos el temporal
        # si son distintos, borramos el temporal y el archivo del servidor con FTP.
        if [ "$local_md5" == "$remote_md5" ]; then
            echo "La verificación del hash MD5 fue exitosa. Eliminando el archivo de checksum local."
            rm -f "$CHECKSUM_DIR/$BACKUPFILENAME"
        else
            echo "Error: La verificación del hash MD5 falló. Eliminando el archivo del FTP."
            rm -f "$CHECKSUM_DIR/$BACKUPFILENAME"
            lftp -u "$FTP_USERNAME","$FTP_PASSWORD" "$FTP_SERVER" <<EOF
            set ftp:ssl-force true
            set ftp:ssl-protect-data true
            set ssl:verify-certificate no

            cd "$BACKUPDIRECTORY"
            rm "$BACKUPFILENAME"
            quit
EOF
        fi

    else
        echo "Error al subir la copia de seguridad al servidor FTP."
    fi

else
    echo "Error al crear la copia de seguridad local."
fi
