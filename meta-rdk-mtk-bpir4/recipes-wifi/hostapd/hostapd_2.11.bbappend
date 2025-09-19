FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://hostapd-2G.conf \
    file://hostapd-5G.conf \
    file://hostapd-6G.conf \
"

do_install_append() {
    install -m 755 ${WORKDIR}/hostapd-2G.conf ${D}${sysconfdir}/hostapd-2G.conf
    install -m 755 ${WORKDIR}/hostapd-5G.conf ${D}${sysconfdir}/hostapd-5G.conf
    install -m 755 ${WORKDIR}/hostapd-6G.conf ${D}${sysconfdir}/hostapd-6G.conf
}
