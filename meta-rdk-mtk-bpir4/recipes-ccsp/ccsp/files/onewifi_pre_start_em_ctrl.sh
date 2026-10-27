#!/bin/sh

if [ ! -f /nvram/wifi_defaults.txt ]; then
   cp /usr/ccsp/wifi/wifi_defaults.txt /nvram
fi
if [ ! -f /nvram/InterfaceMap.json ]; then
   cp /usr/ccsp/wifi/InterfaceMap.json /nvram
fi
if [ ! -f /nvram/EasymeshCfg.json ]; then
   cp /usr/ccsp/EasyMesh/EasymeshCfg.json /nvram
fi
if [ ! -f /nvram/Data_Elements_JSON_Schema_v3.0.json ]; then
   cp /usr/ccsp/EasyMesh/Data_Elements_JSON_Schema_v3.0.json /nvram
fi
if [ ! -f /nvram/Reset.json ]; then
   cp /usr/ccsp/EasyMesh/Reset.json /nvram
fi
if [ ! -d /nvram/static ]; then
   cp -rf /usr/ccsp/EasyMesh/static /nvram
fi
if [ ! -f /nvram/test_cert.crt ]; then
   cp /usr/ccsp/EasyMesh/test_cert.crt /nvram
   cp /usr/ccsp/EasyMesh/create-cert /nvram
   cp /usr/ccsp/EasyMesh/test_cert.key /nvram
fi

sleep 20

iw phy phy0 interface add wifi0 type __ap
iw phy phy0 interface add wifi0.1 type __ap
iw phy phy0 interface add wifi0.2 type __ap
iw phy phy0 interface add wifi0.4 type __ap
iw phy phy0 interface add wifi1 type __ap
iw phy phy0 interface add wifi1.1 type __ap
iw phy phy0 interface add wifi1.2 type __ap
iw phy phy0 interface add wifi1.3 type __ap
iw phy phy0 interface add wifi1.4 type __ap
iw phy phy0 interface add wifi2 type __ap
iw phy phy0 interface add wifi2.1 type __ap
iw phy phy0 interface add wifi2.2 type __ap
iw phy phy0 interface add mld0 type __ap radios all

# rdkb-bpi-mac rewrites mac_addresses.txt on every boot. Older builds omit
# the dedicated onboarding VAPs, so append those addresses when they are absent.
# Offsets match rdkb-bpi-mac: wifi0 is list index 4, wifi0.4 index 16, wifi1.4 index 17.
if ! grep -a -q '^wifi0\.4 ' /nvram/mac_addresses.txt || ! grep -a -q '^wifi1\.4 ' /nvram/mac_addresses.txt; then
    wifi0_base=`grep -a '^wifi0 ' /nvram/mac_addresses.txt | cut -d " " -f 2 | head -n1`
    o1=`echo "$wifi0_base" | cut -d: -f1`
    o2=`echo "$wifi0_base" | cut -d: -f2`
    o4=`echo "$wifi0_base" | cut -d: -f4`
    o5=`echo "$wifi0_base" | cut -d: -f5`
    o6=`echo "$wifi0_base" | cut -d: -f6`
    last=$((0x$o6))
    if ! grep -a -q '^wifi0\.4 ' /nvram/mac_addresses.txt; then
        printf 'wifi0.4 %s:%s:14:%s:%s:%02x\n' "$o1" "$o2" "$o4" "$o5" $(( (last + 12) & 255 )) >> /nvram/mac_addresses.txt
    fi
    if ! grep -a -q '^wifi1\.4 ' /nvram/mac_addresses.txt; then
        printf 'wifi1.4 %s:%s:24:%s:%s:%02x\n' "$o1" "$o2" "$o4" "$o5" $(( (last + 13) & 255 )) >> /nvram/mac_addresses.txt
    fi
fi

#Obtain the wifi mac address
wifi0_mac=`cat /nvram/mac_addresses.txt | grep -a wifi0 | cut -d " " -f 2 | head -n1`
wifi0_1_mac=`cat /nvram/mac_addresses.txt | grep -a wifi0.1 | cut -d " " -f 2 | head -n1`
wifi0_2_mac=`cat /nvram/mac_addresses.txt | grep -a wifi0.2 | cut -d " " -f 2 | head -n1`
wifi0_4_mac=`cat /nvram/mac_addresses.txt | grep -a wifi0.4 | cut -d " " -f 2 | head -n1`
wifi1_mac=`cat /nvram/mac_addresses.txt | grep -a wifi1 | cut -d " " -f 2 | head -n1`
wifi2_mac=`cat /nvram/mac_addresses.txt | grep -a wifi2 | cut -d " " -f 2 | head -n1`
wifi1_1_mac=`cat /nvram/mac_addresses.txt | grep -a wifi1.1 | cut -d " " -f 2 | head -n1`
wifi1_2_mac=`cat /nvram/mac_addresses.txt | grep -a wifi1.2 | cut -d " " -f 2 | head -n1`
wifi1_3_mac=`cat /nvram/mac_addresses.txt | grep -a wifi1.3 | cut -d " " -f 2 | head -n1`
wifi1_4_mac=`cat /nvram/mac_addresses.txt | grep -a wifi1.4 | cut -d " " -f 2 | head -n1`
wifi2_1_mac=`cat /nvram/mac_addresses.txt | grep -a wifi2.1 | cut -d " " -f 2 | head -n1`
wifi2_2_mac=`cat /nvram/mac_addresses.txt | grep -a wifi2.2 | cut -d " " -f 2 | head -n1`

#Update the mac address using ip link command
ifconfig wifi0 down
ifconfig wifi0.1 down
ifconfig wifi0.2 down
ifconfig wifi0.4 down
ifconfig wifi1 down
ifconfig wifi1.1 down
ifconfig wifi1.2 down
ifconfig wifi1.3 down
ifconfig wifi1.4 down
ifconfig wifi2 down
ifconfig wifi2.1 down
ifconfig wifi2.2 down

ip link set dev wifi0 address $wifi0_mac
ip link set dev wifi0.1 address $wifi0_1_mac
ip link set dev wifi0.2 address $wifi0_2_mac
ip link set dev wifi0.4 address $wifi0_4_mac
ip link set dev wifi1 address $wifi1_mac
ip link set dev wifi1.1 address $wifi1_1_mac
ip link set dev wifi1.2 address $wifi1_2_mac
ip link set dev wifi1.3 address $wifi1_3_mac
ip link set dev wifi1.4 address $wifi1_4_mac
ip link set dev wifi2 address $wifi2_mac
ip link set dev wifi2.1 address $wifi2_1_mac
ip link set dev wifi2.2 address $wifi2_2_mac

ifconfig wifi0 up
ifconfig wifi0.1 up
ifconfig wifi0.2 up
ifconfig wifi0.4 up
ifconfig wifi1 up
ifconfig wifi1.1 up
ifconfig wifi1.2 up
ifconfig wifi1.3 up
ifconfig wifi1.4 up
ifconfig wifi2 up
ifconfig wifi2.1 up
ifconfig wifi2.2 up

# Set MLD interface address as wifi2 MAC address + 1
prefix="${wifi2_mac%:*}"
last_byte="${wifi2_mac##*:}"

new_byte=$(printf "%02X" $(( (0x$last_byte + 1) & 0xFF )))
new_mac="$prefix:$new_byte"

ip link set dev "mld0" down
ip link set dev "mld0" address "$new_mac"

exit 0
