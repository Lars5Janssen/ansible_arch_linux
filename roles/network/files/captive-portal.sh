PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

if [ -x "/usr/bin/logger" ]; then
  logger="/usr/bin/logger -s -t captive-portal"
else
  logger=":"
fi

exiting() {
    $logger "EXITING"
    exit $1
}

openurl() {
  $logger "Openning $1"
  userid="$(id -u l)"
  # userid="$(id -u)"
  username="l"
  # username="$(id -n -u)"
  sudo -u "$username" DISPLAY=":0" \
    DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/"${userid}"/bus \
    XDG_RUNTIME_DIR=/run/user/"${userid}" \
    xdg-open "$1"
  exiting 0
}

open_captive() {
  captive_url=http://$(ip --oneline route get 1.1.1.1 | awk '{print $3}')
  $logger "captive_url '$captive_url'"
  openurl $captive_url
  exiting 0
}

$logger "last Var '$1'"
case "$1" in
  connectivity-change)
    $logger -p user.debug \
      "dispatcher script triggered on connectivity change: $CONNECTIVITY_STATE"

    if [ "$CONNECTIVITY_STATE" = "PORTAL" ]; then
      user=$(who | head -n1 | cut -d' ' -f 1)

      $logger "Running browser as '$user' to login in captive portal"

      open_captive "$user" || $logger -p user.err "Failed for user: '$user'"
      exiting 0
    fi
    exiting 0
    ;;
  *) 
    $logger "No Captive Portal via NetworkManager"

    url='detectportal.firefox.com/canonical.html'
    curl $url -L
    if [ $? -ne 6 ]; then
        curl 'detectportal.firefox.com/canonical.html' -L | grep --silent 'https://support.mozilla.org/kb/captive-portal'
        if [ $? -eq 0 ]; then
            $logger "No Portal detected via Canonical URL"
        else
            $logger "Detected Portal via Canonical URL"
            openurl http://detectportal.firefox.com/canonical.html
        fi
    fi
    exiting 0
    ;;
esac
