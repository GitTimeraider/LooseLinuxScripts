#!/bin/bash

# Set the maximum number of backup files to keep
BACKUP_LIMIT=3

# Check for existing backup files and delete the oldest if there are already MAX_BACKUPS
backup_count=$(ls /backup_*.tar.gz 2>/dev/null | wc -l)
if [ "$backup_count" -ge "$BACKUP_LIMIT" ]; then
    oldest_backup=$(ls -t /backup_*.tar.gz | tail -1)
    rm "$oldest_backup"
fi

# Create a new backup file with the current date
backup_file="/backup_$(date +%Y-%m-%d).tar.gz"

# Create the tar archive and suppress errors
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

# Simple progress indicator
pid=$!
while kill -0 $pid 2>/dev/null; do
    echo -n "."
    sleep 10
done

echo "Backup completed: $backup_file"
