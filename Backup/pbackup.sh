#!/bin/bash

# Script mode. Can be either backup or restore .. executes the specified part of the script
MODE="restore"

# Check the mode and execute the corresponding part of the script
if [ "$MODE" == "backup" ]; then

    ### BACKUP MODE
    # Set the maximum number of backup files to keep
    BACKUP_LIMIT=4

    # Set the backup location. End the location with /
    BACKUP_LOCATION="/mnt/"

    # Check for existing backup files and delete the oldest if it reached the backup limit
    backup_files=$(ls ${BACKUP_LOCATION}pbackup_*.tar.gz 2>/dev/null)
    backup_count=$(echo "$backup_files" | wc -l)
    if [ "$backup_count" -ge "$BACKUP_LIMIT" ]; then
        oldest_backup=$(echo "$backup_files" | tail -1)
        rm "$oldest_backup"
    fi

    # Define a new backup file with the current date
    backup_file="${BACKUP_LOCATION}pbackup_$(date +%Y-%m-%d).tar.gz"

    # Check if a backup file with the same name already exists and delete it if it does
    if [ -f "$backup_file" ]; then
        rm "$backup_file"
    fi

    # Get the size of the most recent backup file for progress calculation
    recent_backup=$(echo "$backup_files" | head -1)
    if [ -n "$recent_backup" ]; then
        recent_backup_size=$(du -sb "$recent_backup" | awk '{print $1}')
    else
        # Set a default size if no previous backups exist
        recent_backup_size=1000000  # 1MB
    fi
    # Add 10% to the recent backup size to make the bar more forgiving for growing backups
    target_size=$((recent_backup_size + recent_backup_size / 10))

    # Ensure target_size is not zero
    if [ "$target_size" -eq 0 ]; then
        target_size=1000000  # 1MB
    fi

    # Function to show progress bar
    show_progress() {
        local current_size
        while [ -d /proc/$1 ]; do
            if [ -f "$backup_file" ]; then
                current_size=$(du -sb "$backup_file" 2>/dev/null | awk '{print $1}')
                progress=$((current_size * 100 / target_size))
                if [ $progress -gt 100 ]; then
                    progress=100
                fi
                echo -ne "\rProgress: $progress%"
            else
                echo -ne "\rProgress: 0%"
            fi
            sleep 10
        done
        echo -ne "\rProgress: 100%\n"
    }

    # Create the tar archive in the background
    {
        sudo tar czf "$backup_file" \
            --exclude="$backup_file" \
            --exclude=/dev \
            --exclude=/mnt \
            --exclude=/proc \
            --exclude=/sys \
            --exclude=/tmp \
            --exclude=/media \
            --exclude=/lost+found \
            / 2>/dev/null
    } &

    # Show warning
    echo "Wait for the script to finish, even when the progress bar shows 100%!"

    # Show progress bar
    show_progress $!

    echo "Backup completed: $backup_file"

elif [ "$MODE" == "restore" ]; then

    ### RESTORE MODE
    echo "Restore mode is not implemented yet."

else
    echo "Invalid mode: $MODE"
    exit 1
fi
