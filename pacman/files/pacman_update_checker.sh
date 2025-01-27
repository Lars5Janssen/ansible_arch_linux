#!/bin/bash
send-notification ()
{
    XDG_RUNTIME_DIR=/run/user/$(id -u) notify-send "$1" "$2" $3 $4 
}

min_wait=0
max_wait=59
sleep $((min_wait+RANDOM % (max_wait-min_wait)))

if checkupdates
then
    send-notification "Pacman Updates available" --expire-time=1800000
else
    send-notification "No Pacman Updates available"
fi
