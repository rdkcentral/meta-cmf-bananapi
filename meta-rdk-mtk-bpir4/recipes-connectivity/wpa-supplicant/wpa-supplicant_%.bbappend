EXTRA_OEMAKE = "CONFIG_BUILD_WPA_CLIENT_SO=y"
FILES_SOLIBSDEV = ""

SRCREV = "${SRCREV_kernel6-6}"

do_install:append () {
	install -d ${D}${includedir}

	install -m 0777 ${S}/wpa_supplicant/libwpa_client.so  ${D}${libdir}/
	install -m 0644 ${S}/src/common/wpa_ctrl.h ${D}${includedir}/
}

FILES:${PN} += "${includedir}/wpa_ctrl.h"
FILES:${PN} += "${libdir}/rdk"
FILES:${PN} += " /usr/local"
FILES:${PN}-dbg += " /usr/local/"
