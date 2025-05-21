#!/bin/sh
sleep 20

#To update al_mac_addr in EasyMeshCfg.json to avoid onewifi restarting during fresh boot-up
wan_mac="$(cat /sys/class/ieee80211/phy0/macaddress)"
old_al_mac_addr=`cat /nvram/EasymeshCfg.json | grep AL_MAC_ADDR  | cut -d '"' -f4`
if [ "$old_al_mac_addr" == "00:00:00:00:00:00" ]; then
  sed -i "s/$old_al_mac_addr/$wan_mac/g" /nvram/EasymeshCfg.json
fi  

iw phy phy0 interface add wifi0 type __ap
iw phy phy0 interface add wifi1 type __ap
iw phy phy0 interface add wifi2 type __ap

#Obtain the wifi0 mac address
wifi0_mac=`cat /nvram/mac_addresses.txt | grep -a wifi0 | cut -d " " -f 2`
wifi1_mac=`cat /nvram/mac_addresses.txt | grep -a wifi1 | cut -d " " -f 2`
wifi2_mac=`cat /nvram/mac_addresses.txt | grep -a wifi2 | cut -d " " -f 2`
#print the mac address
echo $wifi0_mac
echo $wifi1_mac
echo $wifi2_mac

#Update the mac address using ip link command
ifconfig wifi0 down
ifconfig wifi1 down
ifconfig wifi2 down
ip link set dev wifi0 address $wifi0_mac
ip link set dev wifi1 address $wifi1_mac
ip link set dev wifi2 address $wifi2_mac
ifconfig wifi0 up
ifconfig wifi1 up
ifconfig wifi2 up

exit 0
