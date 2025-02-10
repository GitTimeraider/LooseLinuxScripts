# LooseLinuxScripts - Backup
Description for the scripts:

## pbackup.sh
Script that can be used to backup and restore Linux systems using .tar zipping. <br />
Can be manually adjusted to only backup specific folders if needed (Not through default variables). <br />
As it backups into an .tar, it is possible to restore specific files from it without unzipping the entire package.

### How does it work

When backing up, it saves an .tar.gz in a specified location. That .tar contains all data on the system.<br />
During the backup an progress bar appears. Do not take that to serious as it will often be incorrect. The progress bar is based on the size of the previous backup and tries predicting from there thus usually either ends slightly earlier or slightly later than 100%.

### Variables that can be changed in the script:

MODE: Can be set to either "backup" or "restore" depending on what you want it to do

BACKUP_LOCATION: Location that either holds the backups after backupping or is the location the restore action looks to for backup files. 
Always end this location on /. Example: "/mnt/USB/"

BACKUP_LIMIT: Maximal amount of backups that wil be saved with the backup mode. Removes the oldest backup file if it already reached 4. Only works in backup mode.

RESTORE_LOCATION: Location it restores everything in the backup file to. Only works in restore mode.

Exclusions: Exclusions is not a separate variable. Go into the script up to the --exclude portion of the bacup tar command and copy on of the lines after which you adjust the location for a new exclusion.

### How to disaster recovery

Prepare the New Drive: Ensure the new drive is formatted and has the proper filesystem (usually ext4 for Raspberry Pi).

Restore the Backup: Boot the device from a different medium (such as a USB stick or SD card), and mount the new drive. Then  connect the device containing script and backup files and restore the backup using the script with the correct restore location.

Fix the Bootloader (if needed): After restoring the system, you may need to install the bootloader on the new drive (especially if it's a different drive than the one you are currently booting from). This depends on the boot method you're using (SD card or USB boot). If the new drive is the boot drive, you will need to ensure the boot partition is properly set up.

Check Disk UUIDs: If you changed the disk or partition, make sure the UUIDs in /etc/fstab match the new setup. You can check UUIDs with blkid and update /etc/fstab accordingly.


