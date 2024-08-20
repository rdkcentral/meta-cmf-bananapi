EXTRA_OEMAKE = "CONFIG_BUILD_WPA_CLIENT_SO=y"
FILES_SOLIBSDEV = ""
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
