#!/bin/bash
send-notification ()
{
    ~/scripts/send-user-notification.sh "$1" "$2" $3 $4 
}

mkdir ~/logs/flatpak_updates --parents

DATE="$(date -u +%Y-%m-%d-%H:%M:%S)"

LOG_FILE=~/logs/flatpak_updates/"$DATE".log
flatpak update --assumeyes >> "$LOG_FILE" 2>&1
if cat "$LOG_FILE" | grep --quiet 'errors'
then
    send-notification  "Errors during Flatpak update" --urgency=critical --expire-time=600000
elif cat "$LOG_FILE" | grep --quiet 'Nothing to do.'
then
    send-notification  "Finished Flatpak Update" "Nothing to do"
    rm "$LOG_FILE"
else
    send-notification  "Finished Flatpak Update" "Updated Programms" --expire-time=30000
fi
