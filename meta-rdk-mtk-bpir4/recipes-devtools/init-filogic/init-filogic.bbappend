do_install_append(){

   install -d ${D}${sbindir}
   DISTRO_EM_EXT_ENABLED="${@bb.utils.contains('DISTRO_FEATURES','em_extender','true','false',d)}"
   if [ $DISTRO_EM_EXT_ENABLED = 'false' ]; then
       sed -i '/brctl addif brlan0 lan0/d' ${D}${sbindir}/init-bridge.sh
   fi
sed -i '/model/a \
if [ ! -d /nvram/secure ]; then \
    mkdir -p /nvram/secure \
fi \
rdkmmap \
rdkb-bpi-mac \
if [ $? -eq 0 ];then \
    for i in 0 1 2 3 \
    do \
        LAN_MAC=`cat /nvram/mac_addresses.txt | grep -a lan${i} | cut -d " " -f 2` \
        if [ "x$LAN_MAC" != "x" ]; then \
                ifconfig lan${i} hw ether $LAN_MAC \
        fi \
   done \
   BRLAN_MAC=`cat /nvram/mac_addresses.txt | grep -a brlan0 | cut -d " " -f 2` \
   ifconfig brlan0 hw ether $BRLAN_MAC \
fi' ${D}${sbindir}/init-bridge.sh
}

#ESDK support - Avoid conflict file is installed by both systemd and init-filogic in kirkstone
SYSTEMD_SERVICE:${PN}_remove = "usb-mount@.service"
do_install_append_broadband () {
   rm ${D}${systemd_unitdir}/system/usb-mount@.service
}
