#!/bin/bash
send-notification ()
{
    ~/scripts/send-user-notification.sh "$1" "$2" $3 $4 
}

if [[ $1 == "delay" ]]; then
    min_wait=0
    max_wait=20
    sleep_dur=$((min_wait+RANDOM % (max_wait-min_wait)))
    sleep "$sleep_dur"m
fi

if checkupdates
then
    number_of_updateable_packages="$(checkupdates | wc -l)"
    send-notification "Pacman Updates available" "$number_of_updateable_packages updates available" --expire-time=60000
else
    send-notification "No Pacman Updates available"
fi
