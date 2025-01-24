#!/bin/bash
send-notification ()
{
    XDG_RUNTIME_DIR=/run/user/$(id -u) notify-send "$1" "$2" $3 $4 
}

if ! acpi | grep 'Charging' --quiet
then
    battery_level=`acpi -b | grep -P -o '[0-9]+(?=%)'`
    if [ $battery_level -le $1 ]; then
        urgent=""
        status="low"
        if [[ $2 == "critical" ]]; then
            display_brightness="$(brightnessctl | grep '%' | awk '{ print $4 }' | sed 's/(//' | sed 's/%)//')"
            if [ $display_brightness -gt 31 ]; then
                if [ $display_brightness -gt 29 ]; then
                    brightnessctl set 30% 
                fi
            fi
            status="critical!"
            urgent="--urgency=critical --expire-time=10000"
        fi
        send-notification "Battery ${status}" "Battery level is ${battery_level}%!" $urgent
    fi
fi
