import datetime
import shutil
import os
from pydrive.auth import GoogleAuth
from pydrive.drive import GoogleDrive

gauth = GoogleAuth()
gauth.LocalWebserverAuth()

drive = GoogleDrive(gauth)


date = datetime.datetime.now()

nameBackup = "Backup_{}{}{}_{}{}".format(
                date.year, 
                str(date.month).zfill(2), 
                str(date.day).zfill(2), 
                str(date.hour).zfill(2),
                str(date.minute).zfill(2)
              )

shutil.make_archive(nameBackup,"zip","Backup_Daily")
fileDrive = drive.CreateFile({'title': f"{nameBackup}.zip"})
fileDrive.SetContentFile(f"./{nameBackup}.zip")
fileDrive.Upload()
os.remove(f"./{nameBackup}.zip")

print("Copia de seguridad creada exitosamente")
