# ${{\color{Purple}\Huge{\textsf{pbackup.sh\}}}}\$

Run script as sudo!

Script that can be used to backup and restore Linux files and folders using .tar zipping. <br />
Can be manually adjusted to only backup specific folders if needed (Not through default variables). <br />
As it backups into an .tar, it is possible to restore specific files from it without unzipping the entire package.

## How does it work

When backing up, it saves an .tar.gz in a specified location. That .tar contains all data on the system.<br />
During the backup an progress bar appears. Do not take that to serious as it will often be incorrect. The progress bar is based on the size of the previous backup and tries predicting from there thus usually either ends slightly earlier or slightly later than 100%.<br />
This is also why the first run, it will be extremely off due to having no comparison file

## Variables that can be changed in the script:

MODE: Can be set to either "backup" or "restore" depending on what you want it to do

BACKUP_LOCATION: Location that either holds the backups after backupping or is the location the restore action looks to for backup files. 
Always end this location on /. Example: "/mnt/USB/"

BACKUP_LIMIT: Maximal amount of backups that wil be saved with the backup mode. Removes the oldest backup file if it already reached 4. Only works in backup mode.

Exclusions: Exclusions is not a separate variable. Go into the script up to the --exclude portion of the bacup tar command and fully copy one of the lines after which you adjust the location for a new exclusion.

## Restoring specific files

Script needs to be in MODE="restore"<br />
Run the script to choose what backup file to restore from, what to restore and where to restore to.<br />
Existing files with the same name will be overwritten!
This does use the BACKUP_LOCATION variable to determine where the backups are location.

## How to disaster recovery

To restore the backup you created on a different disk, you can follow these general steps:

1. Prepare the New Disk:
Partition the new disk: If the new disk is not partitioned, you’ll need to partition it. You can use tools like fdisk, parted, or gparted for this. Make sure you create partitions that match the ones on your original system.
Format the partitions: After partitioning, format them using an appropriate file system (e.g., ext4) with commands like:
mkfs.ext4 /dev/sdX1
Replace /dev/sdX1 with the actual partition you want to format.

2. Mount the New Disk:
Mount the new disk’s root partition (or wherever you want to restore the backup):

mount /dev/sdX1 /mnt
Replace /dev/sdX1 with the actual partition.

3. Mount Required Filesystems:
If necessary, mount directories like /proc, /sys, and /dev to ensure the system functions properly during the restoration:

mount --bind /dev /mnt/dev
mount --bind /proc /mnt/proc
mount --bind /sys /mnt/sys

4. Extract the Backup:
Now, extract the backup you created onto the new disk. Assuming your backup file is available (e.g., /path/to/backup.tar.gz), use the following command:

sudo tar xzpf /path/to/backup.tar.gz -C /mnt
This will extract the backup into /mnt, which is the root of the new disk.

5. Reconfigure the System:
After restoring the system, there are a few things you’ll need to do:

Check /etc/fstab: If the disk UUIDs or mount points have changed, make sure to update /mnt/etc/fstab to reflect the new partition setup. You can find the UUIDs by running:

blkid

Update GRUB: You might need to reinstall and reconfigure GRUB if you're booting from this new disk. Mount the necessary filesystems and run the following command:

mount --bind /dev /mnt/dev
mount --bind /proc /mnt/proc
mount --bind /sys /mnt/sys
chroot /mnt
grub-install /dev/sdX
update-grub
Replace /dev/sdX with the appropriate disk, typically the one you want to install the bootloader to (usually /dev/sda or /dev/sdb).

Regenerate initramfs: Ensure that the initramfs is regenerated for the new system:

update-initramfs -u
Network Configuration: Ensure that the network settings are correct, especially if you're using DHCP or static IPs. Check the /mnt/etc/network/interfaces or /mnt/etc/netplan/ directory (depending on your distribution) and update them if necessary.

6. Reboot the System:
Once everything is set up and configured, unmount the mounted directories and reboot the system:

umount /mnt/dev /mnt/proc /mnt/sys
umount /mnt
reboot
After rebooting, the system should now boot from the new disk with the same configuration and data as the original disk.

