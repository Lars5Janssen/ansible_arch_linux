#!/bin/bash
send-notification ()
{
    XDG_RUNTIME_DIR=/run/user/$(id -u) notify-send "$1" "$2" $3 $4 
}

if ! acpi | grep 'Charging' --quiet
then
    battery_level=`acpi -b | grep -P -o '[0-9]+(?=%)'`
    if [ $battery_level -le $1 ]
    then
        urgent=""
        status="low"
        if [[ $2 == "critical" ]]; then
            status="critical!"
            urgent="--urgency=critical --expire-time=30000"
        fi
        send-notification "Battery ${status}" "Battery level is ${battery_level}%!" $urgent
    fi
fi
