#!/bin/bash

# Check for existing backup files and delete the oldest if there are already 3
backup_count=$(ls /backup_*.tar.gz 2>/dev/null | wc -l)
if [ "$backup_count" -ge 3 ]; then
    oldest_backup=$(ls -t /backup_*.tar.gz | tail -1)
    rm "$oldest_backup"
fi

# Create a new backup file with the current date
sudo tar czf /backup_$(date +%Y-%m-%d).tar.gz \
    --exclude=/backup_$(date +%Y-%m-%d).tar.gz \
    --exclude=/dev \
    --exclude=/mnt \
    --exclude=/proc \
    --exclude=/sys \
    --exclude=/tmp \
    --exclude=/media \
    --exclude=/lost+found \
    /
