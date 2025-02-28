#!/bin/sh
sleep 5
iw phy phy0 interface add wifi0 type __ap
iw phy phy0 interface add wifi1 type __ap
#iw phy phy0 interface add wifi2 type __ap

#Obtain the wifi0 mac address
wifi0_mac="$(cat /sys/class/ieee80211/phy0/macaddress)"
#Strip the : and increment mac by 1 to get wifi1 macaddress
mac=$(echo $wifi0_mac | tr -d ':')
mac_incr=$((0x$mac + 1))
wifi1_mac=$(printf "%012x" $mac_incr | sed 's/../&:/g;s/:$//')
#Increment again by 1 to get wifi2 address
mac_incr=$(($mac_incr + 1))
wifi2_mac=$(printf "%012x" $mac_incr | sed 's/../&:/g;s/:$//')
#print the mac address
echo $wifi0_mac
echo $wifi1_mac
#echo $wifi2_mac

#Update the mac address using ip link command
ifconfig wifi0 down
ifconfig wifi1 down
#ifconfig wifi2 down
ip link set dev wifi0 address $wifi0_mac
ip link set dev wifi1 address $wifi1_mac
#ip link set dev wifi2 address $wifi2_mac
ifconfig wifi0 up
ifconfig wifi1 up
#ifconfig wifi2 up

modprobe gpio_keys
EVENT_DEVICE="/dev/input/event0"  # Confirmed from evtest
VAP_INDEX_2G=0  # Virtual AP index for OneWifi
VAP_INDEX_5G=1  # Virtual AP index for OneWifi
VAP_INDEX_6G=2  # Virtual AP index for OneWifi
LOGFILE="/tmp/wps_trigger.log"

echo "Listening for WPS button press on $EVENT_DEVICE..." | tee -a $LOGFILE

# Read event stream and trigger WPS when KEY_WPS_BUTTON (529) is detected
evtest "$EVENT_DEVICE" | while read line; do
    if echo "$line" | grep -q "code 529 (KEY_WPS_BUTTON), value 1"; then
        echo "✅ WPS Button Pressed! Triggering OneWifi WPS for 2G, 5G and 6G..." | tee -a $LOGFILE

        # Kill any existing interactive session before triggering WPS
        pkill -f onewifi_component_test_app

        # Run WPS command and log output
        echo "Executing: echo 'wps $VAP_INDEX' | /usr/bin/onewifi_component_test_app" | tee -a $LOGFILE
        echo "wps $VAP_INDEX_2G" | /usr/bin/onewifi_component_test_app >> $LOGFILE 2>&1

        echo "wps $VAP_INDEX_5G" | /usr/bin/onewifi_component_test_app >> $LOGFILE 2>&1

        echo "wps $VAP_INDEX_6G" | /usr/bin/onewifi_component_test_app >> $LOGFILE 2>&1

        sleep 5  # Prevent multiple triggers within 5 seconds
    fi
done

exit 0
