# LooseLinuxScripts - Backup
Description for the scripts:

## pbackup.sh
Script that can be used to backup and restore Linux systems using .tar zipping. Can be manually adjusted to only backup specific folders if needed (Not through default variables)

### Variables that can be changed in the script:

MODE: Can be set to either "backup" or "restore" depending on what you want it to do

BACKUP_LOCATION: Location that either holds the backups after backupping or is the location the restore action looks to for backup files. 
Always end this location on /. Example: "/mnt/USB/"

BACKUP_LIMIT: Maximal amount of backups that wil be saved with the backup mode. Removes the oldest backup file if it already reached 4. Only works in backup mode.

RESTORE_LOCATION: Location it restores everything in the backup file to. Only works in restore mode.

### How does it work

When backing up, it saves an .tar.gz in a specified location. That .tar contains all data on the system.

During the backup an progress bar appears. Do not take that to serious as it will often be incorrect. The progress bar is based on the size of the previous backup and tries predicting from there thus usually either ends slightly earlier or slightly later than 100%.

### How to restore

Set up a new SD card or disk by either setting up an linux partition manually using (fdisk or gparted) or install an linux-based OS on it with the idea to have that set it up and then overwrite everything.
Connect/mount it to a different device so system files will not be in use and then either use restore mode of the script or use any unzipper in any OS to unzip the files and let it unzip onto the empty partition or overwrite the new OS files on the highest level.
