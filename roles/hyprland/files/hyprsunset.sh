#!/bin/bash

# First obtain a location code from: https://weather.codes/search/

todays_date="$(date +%Y-%m-%d)"

# Insert your location. For example LOXX0001 is a location code for Bratislava, Slovakia
location="LOXX0001"
tmpfile="/tmp/$location-$todays_date.out"

# Obtain sunrise and sunset raw data from weather.com
if [ ! -f $tmpfile ]; then
    echo "Pulling new Sunrise Data"
    wget -q "https://weather.com/weather/today/l/$location" -O "$tmpfile"
fi

SUNS=$(grep SunriseSunset "$tmpfile" | grep -oE '((1[0-2]|0?[1-9]):([0-5][0-9]) ?([AaPp][Mm]))' | tail -1)

sunset=$(date --date="$SUNS" +%s)
current=$(date +%s)


if [ $current -ge $sunset ]; then
    if ! pidof hyprsunset; then
        hyprsunset -t $1 &
    fi
else
    killall hyprsunset
fi
