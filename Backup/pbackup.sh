#!/bin/bash

# Script mode. Can be either backup or restore .. executes the specified part of the script
MODE="backup"
# Set the backup location. End the location with /
BACKUP_LOCATION="/mnt/"

### Backup Variables. Only work in backup mode
# Set the maximum number of backup files to keep
BACKUP_LIMIT=4 

### Restore variables. Only work in restore mode
# Location to restore to
RESTORE_LOCATION="/"

 # Function to print a dot every 15 seconds
print_dots() {
    while kill -0 $1 2>/dev/null; do
        echo -n "."
        sleep 15
    done
}
# Check the mode and execute the corresponding part of the script
if [ "$MODE" == "backup" ]; then

    ### BACKUP MODE
    # Check for existing backup files and delete the oldest if it reached the backup limit
    backup_files=$(ls ${BACKUP_LOCATION}pbackup_*.img 2>/dev/null)
    backup_count=$(echo "$backup_files" | wc -l)
    if [ "$backup_count" -ge "$BACKUP_LIMIT" ]; then
        oldest_backup=$(echo "$backup_files" | tail -1)
        rm "$oldest_backup"
    fi

    # Define a new backup file with the current date
    backup_file="${BACKUP_LOCATION}pbackup_$(date +%Y-%m-%d).img"

    # Check if a backup file with the same name already exists and delete it if it does
    if [ -f "$backup_file" ]; then
        rm "$backup_file"
    fi

    echo "Backup started!"

    # Run the dd command and print dots in the background
    (print_dots $$) &
    dot_pid=$!
    sudo dd if=/dev/sda of="$backup_file" bs=4M status=progress
    kill $dot_pid

    echo "Backup completed: $backup_file"

elif [ "$MODE" == "restore" ]; then

    ### RESTORE MODE
    echo "Available backup files that can be restored:"
    backup_files=($(ls ${BACKUP_LOCATION}pbackup_*.img 2>/dev/null))
    if [ ${#backup_files[@]} -eq 0 ]; then
        echo "No backup files found in ${BACKUP_LOCATION}"
        exit 1
    fi

    PS3="Which file do you want to restore? "
    select file in "${backup_files[@]}"; do
        if [ -n "$file" ]; then
            echo "You selected: $file"
            echo "Restoring backup to ${RESTORE_LOCATION}..."
            echo "Please be patient while the backup is being restored"

            # Run the dd command and print dots in the background
            (print_dots $$) &
            dot_pid=$!
            sudo dd if="$file" of=/dev/sda bs=4M status=progress
            kill $dot_pid

            echo "Restore completed."
            break
        else
            echo "Invalid selection. Please try again."
        fi
    done

else
    echo "Invalid mode: $MODE"
    exit 1
fi
