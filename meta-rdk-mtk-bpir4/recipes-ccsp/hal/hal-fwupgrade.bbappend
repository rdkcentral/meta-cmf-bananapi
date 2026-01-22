DESCRIPTION = "HAL Firmware Upgrade for BPI"
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI_remove = "git://git01.mediatek.com/filogic/rdk-b/rdkb_hal;branch=master;protocol=https;name=fwupgradehal \
           file://LICENSE;subdir=git \
          "
SRC_URI_append = "git://github.com/rdkcentral/rdkb-hal-bpi;branch=develop;protocol=https;name=fwupgradehal \
           file://start_cron.sh \
                "
LIC_FILES_CHKSUM = "file://../../LICENSE;md5=3b83ef96387f14655fc854ddc3c6bd57"

SRCREV_fwupgradehal = "a18b3f87fe30b5de5c983799bf06b16703e192ee"
do_install_append () {
         install -d ${D}${bindir}
        install -v -m 0755 ${WORKDIR}/start_cron.sh ${D}${bindir}/start_cron
}
FILES:${PN} += "${bindir}/start_cron"
DEPENDS_append += " cjson "
RDEPENDS_${PN}_append = " cjson "
CFLAGS_append = "-I${STAGING_INCDIR}/cjson "
LDFLAGS += "-lcjson"
S = "${WORKDIR}/git/source/fwupgrade"
DEPENDS += " rdkb-halif-fwupgrade"
