EXTRA_OEMAKE = "CONFIG_BUILD_WPA_CLIENT_SO=y"
FILES_SOLIBSDEV = ""
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

DEPENDS_remove += "${@bb.utils.contains('DISTRO_FEATURES', 'OneWifi', 'ubus udebug', '', d)}"
SRC_URI_append = "${@bb.utils.contains('DISTRO_FEATURES', 'OneWifi', ' file://0001-remove-ubus-on-rdkb.patch', '', d)}"
do_configure:append() {
    if ${@bb.utils.contains('DISTRO_FEATURES', 'OneWifi', 'true', 'false', d)}; then
        sed -i 's/^CONFIG_UBUS=y/# CONFIG_UBUS is not set/' ${S}/wpa_supplicant/.config
        sed -i 's/^CONFIG_UCODE=y/# CONFIG_UCODE is not set/' ${S}/wpa_supplicant/.config
    fi
}

do_install_append () {
        install -d ${D}${includedir}
        install -d ${D}${libdir}
        install -d ${D}/lib/rdk/

        install -m 0777 ${S}/wpa_supplicant/libwpa_client.so  ${D}${libdir}/
        install -m 0644 ${S}/src/common/wpa_ctrl.h ${D}${includedir}/
}
FILES_${PN} += "${libdir}/libwpa_client.so"
FILES_${PN} += "${includedir}/wpa_ctrl.h"
FILES_${PN} += "lib/rdk"
FILES_${PN} += " /usr/local"
FILES:${PN}-dbg += " /usr/local/"
