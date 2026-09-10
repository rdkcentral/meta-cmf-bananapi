#!/bin/sh


CRON_JOB="*/15 * * * * /usr/bin/fwupgrade >> /var/log/fwupgrade_cron.log 2>&1"


crontab -l 2>/dev/null | grep -qF "/usr/bin/fwupgrade" || (
    crontab -l 2>/dev/null; echo "$CRON_JOB"
) | crontab -
partitions=(8 10 11 12 13)

for part_num in "${partitions[@]}"; do
    part="/dev/mmcblk0p${part_num}"
blkid_output=$(blkid "$part")
    if echo "$blkid_output" | grep -q 'TYPE="'; then
        echo "Partition $part is already formatted. Skipping."
    else
          mkfs.ext4 -F "$part"
    fi
done
