DESCRIPTION = "HAL Firmware Upgrade for BPI"
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI_append = " \
           file://start_cron.sh \
                "

do_install_append () {
         install -d ${D}${bindir}
        install -v -m 0755 ${WORKDIR}/start_cron.sh ${D}${bindir}/start_cron
}
FILES:${PN} += "${bindir}/start_cron"
DEPENDS_append += " cjson "
RDEPENDS_${PN}_append = " cjson "
CFLAGS_append = "-I${STAGING_INCDIR}/cjson "
LDFLAGS += "-lcjson"
DEPENDS += " rdkb-halif-fwupgrade"
