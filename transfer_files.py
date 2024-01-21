import paramiko
import os
import logging
from datetime import datetime
from dotenv import load_dotenv

# loading env variables
load_dotenv(dotenv_path='src\settings.env')

# setting up logger
logging.basicConfig(format='%(asctime)s [%(levelname)s]: %(message)s', 
                    level=logging.INFO, 
                    filename=f"logs/transfer-file-logs-{datetime.now().strftime('%d-%m-%y-%H%M')}.log",
                    filemode="a")
logging.info("STARTING TRANSFER FILES PROCESS")

# setting up ssh client connection
try:
    ssh = paramiko.SSHClient()
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy()) # not recommended. Used for learning purposes
    ssh.connect(os.environ.get("REMOTE_HOST_IP"), username=os.environ.get("REMOTE_HOST_USER"), key_filename=os.environ.get("SSH_KEY"),port=os.environ.get("SSH_PORT"))
except Exception as e:
    logging.error("ENDING PROGRAM FOR EXCEPTION:")
    logging.error(e)
else:
    # setting sftp connection
    try:
        ftp_client=ssh.open_sftp()
        logging.info(f"SENDING FILE AT {os.environ.get('archivo_origen')} TO REMOTE HOST {os.environ.get('REMOTE_HOST_IP')}:{os.environ.get('SSH_PORT')} AT ~/remote-backups/{os.environ.get('nombre_archivo_destino')}")
        ftp_client.put(f"{os.environ.get('archivo_origen')}",f"remote-backups/{os.environ.get('nombre_archivo_destino')}")
        logging.info("SENT SUCCESSFULLY... EXITING...")
    except Exception as e:
        logging.error("ENDING PROGRAM FOR EXCEPTION:")
        logging.error(e)
    finally:
        ftp_client.close()
        ssh.close()