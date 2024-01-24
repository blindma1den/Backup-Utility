Backup-Utility

This script automates the regular backup process for specified directories on a Linux server. It creates timestamped backup files. For educational purposes only.

How it works?

Verify SSH connectivity between the servers.
Generate SSH keys on the local server, if you don't have them.
Copy the script to the local server, using a text editor such as nano or vim.
Make sure the directory paths correspond to your local and remote servers, or source server and destination server
Assign execute permission to the script using the command: "chmod +x backup.sh"
From the local server, run the backup script from the terminal using the command: "./backup.sh".
This will compress the backup file and send it to the remote server via SCP.
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
