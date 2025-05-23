#!/bin/bash

# Script mode. Can be either backup or restore .. executes the specified part of the script
MODE="backup"
# Set the backup location. End the location with /
BACKUP_LOCATION="/mnt/"

### Backup Variables. Only work in backup mode
# What folder or file to backup?
BACKUP_TARGET="/"
# Set the maximum number of backup files to keep
BACKUP_LIMIT=4
# Add additional exclusions
BACKUP_EXCLUDE=""

# Check the mode and execute the corresponding part of the script
if [ "$MODE" == "backup" ]; then

    ### BACKUP MODE
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
        recent_backup_size=10000000000  # 10GB
    fi
    # Add 10% to the recent backup size to make the bar more forgiving for growing backups
    target_size=$((recent_backup_size + recent_backup_size / 10))

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
        sudo tar czpf "$backup_file" \
            --exclude="$backup_file" \
            --exclude=/dev \
            --exclude=/mnt \
            --exclude=/proc \
            --exclude=/sys \
            --exclude=/tmp \
            --exclude=/media \
            --exclude=/lost+found \
            --exclude="$BACKUP_EXCLUDE" \
            "$BACKUP_TARGET" 2>/dev/null
    } &

    # Show warning
    echo "Backup started!"
    echo "Wait for the script to finish, even when the progress bar shows 100%!"

    # Show progress bar
    show_progress $!

    echo "Backup completed: $backup_file"

elif [ "$MODE" == "restore" ]; then

    ### RESTORE MODE
    echo "Available backup files that can be used:"
    backup_files=($(ls ${BACKUP_LOCATION}pbackup_*.tar.gz 2>/dev/null))
    if [ ${#backup_files[@]} -eq 0 ]; then
        echo "No backup files found in ${BACKUP_LOCATION}"
        exit 1
    fi

    PS3="Which backup do you want to restore from? "
    select file in "${backup_files[@]}"; do
        if [ -n "$file" ]; then
            echo "You selected: $file"
            
            # Prompt for restore location
            read -p "Enter the location to restore to. Example: /mnt/USB " RESTORE_LOCATION
            
            # Prompt for files to extract
            read -p "Enter the files/folders to extract (leave empty to restore entire backup). Do NOT start with an /. Example: etc/xml : " FILES_TO_EXTRACT

            echo "Restoring backup to ${RESTORE_LOCATION}..."
            echo "Please be patient while the backup is being restored"

            # Function to print a dot every 15 seconds
            print_dots() {
                while kill -0 $1 2>/dev/null; do
                    echo -n "."
                    sleep 15
                done
            }

            # Run the tar command and print dots in the background
            (print_dots $$) &
            dot_pid=$!
            if [ -z "$FILES_TO_EXTRACT" ]; then
                sudo tar xzpf "$file" --overwrite -C "${RESTORE_LOCATION}/"
            else
                sudo tar xzpf "$file" --overwrite -C "${RESTORE_LOCATION}/" $FILES_TO_EXTRACT
            fi
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
