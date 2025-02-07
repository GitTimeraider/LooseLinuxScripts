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
