#! /bin/sh
#
# Runs shows a login webpage on walled garden networks.

# man 8 NetworkManager-dispatcher
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

if [ -x "/usr/bin/logger" ]; then
  logger="/usr/bin/logger -s -t captive-portal"
else
  logger=":"
fi

$logger "first '$2'"
$logger "start Fork"
/etc/NetworkManager/middlelayer.sh $2 &
$logger "end Fork"
