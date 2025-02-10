# LooseLinuxScripts - Backup
Description for the scripts:

## pbackup.sh
Script that can be used to backup and restore Linux systems using .tar zipping. Can be manually adjusted to only backup specific folders if needed (Not through default variables)

### Variables that can be changed in the script:

MODE: Can be set to either "backup" or "restore" depending on what you want it to do

BACKUP_LOCATION: Location that either holds the backups after backupping or is the location the restore action looks to for backup files. 
Always end this location on /. Example: "/mnt/USB/"

BACKUP_LIMIT: Maximal amount of backups that wil be saved with the backup mode. Removes the oldest backup file if it already reached 4. Only works in backup mode.

### How does it work

When backing up, it saves an .img.gz in a specified location. That .img contains the entire main disk (/dev/sda).
When restoring it unzip the .img and then restores everything to the /dev/sda that is connected at that time.

### How to restore

Using restore mode, it unpacks the img and then replaces the current /dev/sda, meaning its best to execute this script from an externally mounted disk or OS.
