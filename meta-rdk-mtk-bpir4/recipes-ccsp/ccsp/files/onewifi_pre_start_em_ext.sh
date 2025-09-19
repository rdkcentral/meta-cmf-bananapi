#!/bin/sh
sleep 5

iw phy phy0 interface add wifi0 type __ap
iw phy phy0 interface add wifi0.1 type __ap
iw phy phy0 interface add wifi0.2 type __ap
iw phy phy0 interface add wifi1 type __ap
iw phy phy0 interface add wifi1.1 type __ap
iw phy phy0 interface add wifi1.2 type __ap
iw phy phy0 interface add wifi1.3 type __ap
iw phy phy0 interface add wifi2 type __ap
iw phy phy0 interface add mld0 type __ap radios all

#Obtain the wifi mac address
wifi0_mac=`cat /nvram/mac_addresses.txt | grep -a wifi0 | cut -d " " -f 2 | head -n1`
wifi0_1_mac=`cat /nvram/mac_addresses.txt | grep -a wifi0.1 | cut -d " " -f 2 | head -n1`
wifi0_2_mac=`cat /nvram/mac_addresses.txt | grep -a wifi0.2 | cut -d " " -f 2 | head -n1`
wifi1_mac=`cat /nvram/mac_addresses.txt | grep -a wifi1 | cut -d " " -f 2 | head -n1`
wifi2_mac=`cat /nvram/mac_addresses.txt | grep -a wifi2 | cut -d " " -f 2`
wifi1_1_mac=`cat /nvram/mac_addresses.txt | grep -a wifi1.1 | cut -d " " -f 2 | head -n1`
wifi1_2_mac=`cat /nvram/mac_addresses.txt | grep -a wifi1.2 | cut -d " " -f 2 | head -n1`
wifi1_3_mac=`cat /nvram/mac_addresses.txt | grep -a wifi1.3 | cut -d " " -f 2 | head -n1`

#Update the mac address using ip link command
ifconfig wifi0 down
ifconfig wifi0.1 down
ifconfig wifi0.2 down
ifconfig wifi1 down
ifconfig wifi1.1 down
ifconfig wifi1.2 down
ifconfig wifi1.3 down
ifconfig wifi2 down

ip link set dev wifi0 address $wifi0_mac
ip link set dev wifi0.1 address $wifi0_1_mac
ip link set dev wifi0.2 address $wifi0_2_mac
ip link set dev wifi1 address $wifi1_mac
ip link set dev wifi1.1 address $wifi1_1_mac
ip link set dev wifi1.2 address $wifi1_2_mac
ip link set dev wifi1.3 address $wifi1_3_mac
ip link set dev wifi2 address $wifi2_mac

ifconfig wifi0 up
ifconfig wifi0.1 up
ifconfig wifi0.2 up
ifconfig wifi1 up
ifconfig wifi1.1 up
ifconfig wifi1.2 up
ifconfig wifi1.3 up
ifconfig wifi2 up

# Set MLD interface address as wifi2 MAC address + 1
prefix="${wifi2_mac%:*}"
last_byte="${wifi2_mac##*:}"

new_byte=$(printf "%02X" $(( (0x$last_byte + 1) & 0xFF )))
new_mac="$prefix:$new_byte"

ip link set dev "mld0" down
ip link set dev "mld0" address "$new_mac"

#To update al_mac addr in EasymesgCfg.json
al_mac_addr=`cat /nvram/EasymeshCfg.json | grep AL_MAC_ADDR  | cut -d '"' -f4`
al_mac=`iw dev wifi1.3 info | grep addr | cut -d ' ' -f2`
                 
if [ "$al_mac_addr" = "00:00:00:00:00:00" ]; then
        sed -i "s/$al_mac_addr/$al_mac/g" /nvram/EasymeshCfg.json
fi

exit 0
