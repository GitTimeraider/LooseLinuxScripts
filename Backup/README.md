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
