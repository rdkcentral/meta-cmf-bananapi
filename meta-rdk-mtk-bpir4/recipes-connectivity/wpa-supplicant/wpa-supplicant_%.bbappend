EXTRA_OEMAKE = "CONFIG_BUILD_WPA_CLIENT_SO=y"
FILES_SOLIBSDEV = ""
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI += "file://0001-remove-ubus-from-rdkb.patch;apply=no"
do_apply_patch() {
    cd ${S}
    patch -p1 < ${WORKDIR}/0001-remove-ubus-from-rdkb.patch
}
addtask apply_patch after do_configure before do_compile 
do_configure:append() {
    sed -i 's/^CONFIG_UBUS=y/# CONFIG_UBUS is not set/' ${S}/wpa_supplicant/.config
    sed -i 's/^CONFIG_UCODE=y/# CONFIG_UCODE is not set/' ${S}/wpa_supplicant/.config
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
DEPENDS_remove += "ubus udebug"

