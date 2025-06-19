search_term=$1
name="50-disable-wakeup-for-"$search_term".rules"
lsusb_search="$(lsusb | grep $search_term | awk '{print $6}' | sed 's/:/ /g')"
lsusb_search_one="$(echo $lsusb_search | awk '{print $1}')"
lsusb_search_two="$(echo $lsusb_search | awk '{print $2}')"
sys_search="$(grep $lsusb_search_two /sys/bus/usb/devices/*/idProduct | sed 's%/% %g' | awk '{print $5}' | sed 's/\./ /g' | awk '{print $1}')"

rule="$(echo "ACTION==\"add\", SUBSYSTEM==\"usb\", DRIVERS==\"usb\", ATTRS{idVendor}==\"$lsusb_search_one\", ATTRS{idProduct}==\"$lsusb_search_two\", ATTR{power/wakeup}=\"disabled\", ATTR{driver/$sys_search/power/wakeup}=\"disabled\"")"
path="/etc/udev/rules.d/"$name
echo $path
rm -f $path
echo $rule >> $path
udevadm control --reload-rules && sudo udevadm trigger
