FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://hostapd-2G.conf \
    file://hostapd-5G.conf \
    file://hostapd-6G.conf \
    file://hostapd-init-EHT.patch;apply=no \
"

do_bpi_hostapd_patch(){
   if [ ! -f ${S}/hostapd-init-EHT.sh ]; then
   cp ${WORKDIR}/hostapd-init-EHT.sh ${S}
   cp ${WORKDIR}/hostapd-init-EHT.patch ${S}
   patch -p1 ${S}/hostapd-init-EHT.sh < ${S}/hostapd-init-EHT.patch
   fi
}
addtask bpi_hostapd_patch after do_patch before do_compile

do_install_append() {
    install -m 755 ${WORKDIR}/hostapd-2G.conf ${D}${sysconfdir}/hostapd-2G.conf
    install -m 755 ${WORKDIR}/hostapd-5G.conf ${D}${sysconfdir}/hostapd-5G.conf
    install -m 755 ${WORKDIR}/hostapd-6G.conf ${D}${sysconfdir}/hostapd-6G.conf
    install -m 755 ${S}/hostapd-init-EHT.sh ${D}${base_libdir}/rdk/hostapd-init.sh
}
