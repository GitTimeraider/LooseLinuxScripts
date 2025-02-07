#!/bin/bash

# Set the maximum number of backup files to keep
BACKUP_LIMIT=3

# Check for existing backup files and delete the oldest if there are already MAX_BACKUPS
backup_count=$(ls /backup_*.tar.gz 2>/dev/null | wc -l)
if [ "$backup_count" -ge "$BACKUP_LIMIT" ]; then
    oldest_backup=$(ls -t /backup_*.tar.gz | tail -1)
    rm "$oldest_backup"
fi

# Define a new backup file with the current date
backup_file="/backup_$(date +%Y-%m-%d).tar.gz"

# Get the size of the most recent backup file for progress calculation
recent_backup=$(ls -t /backup_*.tar.gz | head -1)
recent_backup_size=$(du -sb "$recent_backup" | awk '{print $1}')

# Function to show progress bar
show_progress() {
    local current_size
    while [ -d /proc/$1 ]; do
        current_size=$(du -sb "$backup_file" 2>/dev/null | awk '{print $1}')
        progress=$((current_size * 100 / recent_backup_size))
        echo -ne "\rProgress: $progress%"
        sleep 5
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

# Show progress bar
show_progress $!

echo "Backup completed: $backup_file"


# Simple progress indicator
#pid=$!
#while kill -0 $pid 2>/dev/null; do
#    echo -n "."
#    sleep 10
#done

