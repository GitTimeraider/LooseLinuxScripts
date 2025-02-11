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

Prepare the New Disk:

Install the new disk (or SD card) into your device.<br />
Ensure that the new disk is formatted (e.g., with ext4 for Linux-based systems).<br />
Mount the new disk (if it's not already mounted) and identify its device name (e.g., /dev/sda, /dev/mmcblk0, etc.).<br />
Create a Filesystem on the New Disk (if needed): If you are restoring to a fresh disk, you need to create a filesystem on it. You can use the mkfs command to do this, e.g.,:<br />
sudo mkfs.ext4 /dev/sda1  # Replace /dev/sda1 with your new disk partition<br />
Mount the New Disk: Mount the newly formatted disk to a temporary mount point:<br />

sudo mount /dev/sda1 /mnt<br />
Copy the Backup onto the New Disk: Copy the backup tarball (the file you created earlier) from the backup location (e.g., external drive) to the mounted disk.<br />

Example:<br />
sudo cp /path/to/backup.tar.gz /mnt/<br />

Extract the Backup onto the New Disk: Once the backup file is copied to the new disk, navigate to the mount point (/mnt) and extract the backup:<br />
cd /mnt<br />
sudo tar xzpf backup_file.tar.gz -C /<br />
Make sure to replace backup_file.tar.gz with the actual name of your backup file. The -C / option tells tar to extract the backup starting from the root (/) directory of the system.<br />

Reinstall Bootloader (if required): If your new disk is a different disk type (e.g., SSD, USB stick, etc.), you may need to reinstall the bootloader or configure it to boot from the new disk. This can vary based on the Raspberry Pi model and whether you’re using U-Boot or the default bootloader.

To reinstall the bootloader, follow the instructions for your specific setup, for example:<br />
sudo raspi-config<br />
Or follow specific setups for Ubuntu or other Linux variants<br />
Under Advanced Options, you can reconfigure the boot device (SD card or USB).<br />

Update fstab: After the extraction, the system will need to know where to mount its filesystems. You might need to update /etc/fstab to reflect the correct partition UUID or device names for the new disk.

To get the UUIDs of your partitions, use:<br />
sudo blkid<br />
Edit /etc/fstab to reflect the new disk's UUID for the root filesystem (/) and other mounted partitions.

sudo nano /etc/fstab<br />
Make sure the entry for the root filesystem is correct (e.g., /dev/sda1 or the new partition's UUID).

Reboot the System: Once the backup has been restored and the bootloader is reinstalled (if necessary), reboot your Raspberry Pi:
sudo reboot<br />
Verify the Restoration: After the reboot, verify that your system is running correctly. Check whether all the files, configurations, and services are intact.


