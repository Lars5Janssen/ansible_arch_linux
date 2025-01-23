#!/bin/bash
send-notification ()
{
    XDG_RUNTIME_DIR=/run/user/$(id -u) notify-send "$1" "$2" $3 $4 
}

if checkupdates
then
    send-notification "Pacman Updates available" --urgency=critical --expire-time=1800000
else
    send-notification "No Pacman Updates available"
fi
