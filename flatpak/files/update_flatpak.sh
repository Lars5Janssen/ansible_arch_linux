#!/bin/bash
send-notification ()
{
    XDG_RUNTIME_DIR=/run/user/$(id -u) notify-send "$1" "$2" $3 $4 
}

mkdir ~/logs/flatpak_updates --parents

DATE="$(date -u +%Y-%m-%d-%S)"

LOG_FILE=~/logs/flatpak_updates/"$DATE".log
flatpak update --assumeyes 2>&1 >> "$LOG_FILE"
if cat "$LOG_FILE" | grep --quiet 'Nothing to do.'
then
    send-notification  "Finished Flatpak Update" "Nothing to do"
    rm "$LOG_FILE"
else
    send-notification  "Finished Flatpak Update" "Updated Programms" --urgency=critical --expire-time=30000
fi
