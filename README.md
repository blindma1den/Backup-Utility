Este Script tiene la función de hacer un backup local, luego hacer un backup remoto via FTP a un servidor.
Compara que tanto el hash MD5 del archivo local, y del servidor coincidan. Si coinciden lo deja subido y sino lo elimina.
Como tuve problemas para chequear los md5 remotos vía LFTP, el archivo subido lo vuelvo a descargar en una carpeta temporal. Chequeo de forma local el md5 y luego lo elimino. (Seguro se puede hacer mejor, pero estoy aprendiendo).
Para que funcione, debemos crear 3 variables de entorno:

FTP_SERVER
FTP_USERNAME
FTP_PASSWORD



# Backup-Utility
This script  automates the regular backup process for specified directories on a Linux server. It creates timestamped backup files. For educational purposes only.





How it works?



Prepare the Environment:
Ensure you have access to a Linux server or a Linux machine where you want to perform backups.
Create the Script:
Use a text editor such as nano or vi to create the script. You can copy and paste the script code I mentioned earlier. For example:
bash
Copy code
nano backup.sh
Then, paste the script code into the text editor and save it.
Give Execute Permissions to the Script:
Run the following command to give execute permissions to the script:
bash
Copy code
chmod +x backup.sh
Set the Paths:
In the script, make sure to modify the origin and destination variables with the paths of the directories you want to back up and the location where you want to store the backups.
Manually Run the Script:
To manually run the script and perform a backup, simply execute the following command:
bash
Copy code
./backup.sh
The script will compress the files from the source directory and create a backup in the destination directory.
Schedule Automatic Execution (Optional):
If you want the script to run automatically at regular intervals, you can schedule it using the cron utility. To edit the cron table, run:
bash
Copy code
crontab -e
Then, add a line like this to schedule daily execution at a specific time:
bash
Copy code
0 2 * * * /path/to/backup/script.sh
This will run the script every day at 2:00 AM. Adjust the values to suit your specific needs.
Remember to customize the paths and scheduling according to your specific requirements and setup. This script is a basic example, and you can customize it to fit your environment and needs.

