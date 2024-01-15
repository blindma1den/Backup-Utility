#!/bin/ash
#Zona de Variables
data_a_respaldar="/home/csuser/data/info_respaldar"
destino="csbackup@cs-lab-02:~/backup/"
max_retries=3
retry_count=0

#se comprime el fichero antes de enviarlo
compresion="${data_a_respaldar}_$(date +\%Y\%m\%d_\%H\%M\%S).tar.gz"
tar zcf "${compresion}" "${data_a_respaldar}"

#envio de fichero, en caso falle intentara enviarlo las veces que este configurado (max_retries)
while [ $retry_count -lt $max_retries ]; do
	rsync -avz -e ssh "${compresion}" "${destino}"

	#comprobacion de envio
	if [ $? -eq 0 ]; then
    		echo "backup completo"
		break
	else
    		echo "hemos encontrado un error, reintentando"
		retry_count=$((retry_count + 1))
	fi
done

#en dado caso hallamos llegado al maximo de retrys
if [ $retry_count -eq $max_retries ]; then
	echo "Alcanzamos el maximo permitido de reintentos, el backup ha fallado"
fi
