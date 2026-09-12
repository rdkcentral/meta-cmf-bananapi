#!/bin/sh

if [ ! -f /nvram/wifi_defaults.txt ]; then
   cp /usr/ccsp/wifi/wifi_defaults.txt /nvram
fi
if [ ! -f /nvram/InterfaceMap.json ]; then
   cp /usr/ccsp/wifi/InterfaceMap.json /nvram
fi

sleep 20

iw phy phy0 interface add wifi0 type __ap
iw phy phy0 interface add wifi0.1 type __ap
iw phy phy0 interface add wifi0.2 type __ap
iw phy phy0 interface add wifi1 type __ap
iw phy phy0 interface add wifi1.1 type __ap
iw phy phy0 interface add wifi1.2 type __ap
iw phy phy0 interface add wifi1.3 type __ap
iw phy phy0 interface add wifi2 type __ap
iw phy phy0 interface add wifi2.1 type __ap
iw phy phy0 interface add wifi2.2 type __ap
iw phy phy0 interface add mld0 type __ap radios all
iw phy phy0 interface add mld1 type __ap radios all

#Obtain the wifi mac address
wifi0_mac=`cat /nvram/mac_addresses.txt | grep -a wifi0 | cut -d " " -f 2 | head -n1`
wifi0_1_mac=`cat /nvram/mac_addresses.txt | grep -a wifi0.1 | cut -d " " -f 2 | head -n1`
wifi0_2_mac=`cat /nvram/mac_addresses.txt | grep -a wifi0.2 | cut -d " " -f 2 | head -n1`
wifi1_mac=`cat /nvram/mac_addresses.txt | grep -a wifi1 | cut -d " " -f 2 | head -n1`
wifi2_mac=`cat /nvram/mac_addresses.txt | grep -a wifi2 | cut -d " " -f 2 | head -n1`
wifi1_1_mac=`cat /nvram/mac_addresses.txt | grep -a wifi1.1 | cut -d " " -f 2 | head -n1`
wifi1_2_mac=`cat /nvram/mac_addresses.txt | grep -a wifi1.2 | cut -d " " -f 2 | head -n1`
wifi1_3_mac=`cat /nvram/mac_addresses.txt | grep -a wifi1.3 | cut -d " " -f 2 | head -n1`
wifi2_1_mac=`cat /nvram/mac_addresses.txt | grep -a wifi2.1 | cut -d " " -f 2 | head -n1`
wifi2_2_mac=`cat /nvram/mac_addresses.txt | grep -a wifi2.2 | cut -d " " -f 2 | head -n1`

#Update the mac address using ip link command
ifconfig wifi0 down
ifconfig wifi0.1 down
ifconfig wifi0.2 down
ifconfig wifi1 down
ifconfig wifi1.1 down
ifconfig wifi1.2 down
ifconfig wifi1.3 down
ifconfig wifi2 down
ifconfig wifi2.1 down
ifconfig wifi2.2 down

ip link set dev wifi0 address $wifi0_mac
ip link set dev wifi0.1 address $wifi0_1_mac
ip link set dev wifi0.2 address $wifi0_2_mac
ip link set dev wifi1 address $wifi1_mac
ip link set dev wifi1.1 address $wifi1_1_mac
ip link set dev wifi1.2 address $wifi1_2_mac
ip link set dev wifi1.3 address $wifi1_3_mac
ip link set dev wifi2 address $wifi2_mac
ip link set dev wifi2.1 address $wifi2_1_mac
ip link set dev wifi2.2 address $wifi2_2_mac

ifconfig wifi0 up
ifconfig wifi0.1 up
ifconfig wifi0.2 up
ifconfig wifi1 up
ifconfig wifi1.1 up
ifconfig wifi1.2 up
ifconfig wifi1.3 up
ifconfig wifi2 up
ifconfig wifi2.1 up
ifconfig wifi2.2 up

# Set MLD interface address as wifi2.2 MAC address + 1
prefix_mld0="${wifi2_2_mac%:*}"
last_byte_mld0="${wifi2_2_mac##*:}"

new_byte_mld0=$(printf "%02X" $(( (0x$last_byte_mld0 + 1) & 0xFF )))
new_mac_mld0="$prefix_mld0:$new_byte_mld0"

ip link set dev "mld0" down
ip link set dev "mld0" address "$new_mac_mld0"

# Set MLD interface address as mld0 MAC address + 1
prefix_mld1="${new_mac_mld0%:*}"
last_byte_mld1="${new_mac_mld0##*:}"

new_byte_mld1=$(printf "%02X" $(( (0x$last_byte_mld1 + 1) & 0xFF )))
new_mac_mld1="$prefix_mld1:$new_byte_mld1"

ip link set dev "mld1" down
ip link set dev "mld1" address "$new_mac_mld1"

exit 0
