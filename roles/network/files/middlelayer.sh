PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

if [ -x "/usr/bin/logger" ]; then
  logger="/usr/bin/logger -s -t captive-portal"
else
  logger=":"
fi

$logger "Running captive-portal script"

$logger "Var '$1'"

exiting() {
    $logger "EXITING"
    exit $1
}

flock -n /etc/NetworkManager/captive-portal.sh.lock --command "/bin/sh /etc/NetworkManager/captive-portal.sh $1"
if [ $? -ne 0 ]; then
    $logger "Another instance is running"
    exiting 0
fi
