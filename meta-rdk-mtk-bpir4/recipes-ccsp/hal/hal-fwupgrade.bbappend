DESCRIPTION = "HAL Firmware Upgrade for BPI"
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI_remove = "git://git01.mediatek.com/filogic/rdk-b/rdkb_hal;branch=master;protocol=https;name=fwupgradehal \
           file://LICENSE;subdir=git \
          "
SRC_URI_append = "git://github.com/rdkcentral/rdkb-hal-bpi;branch=develop;protocol=https;name=fwupgradehal \
           file://start_cron.sh \
                "
LIC_FILES_CHKSUM = "file://../../LICENSE;md5=3b83ef96387f14655fc854ddc3c6bd57"

SRCREV_fwupgradehal = "2d25cbb860419bd5f9e5ba2511524d8eec3245e4"

EXTRA_OECONF_append = " ${@bb.utils.contains('DISTRO_FEATURES', 'em_extender', 'EM_EXTENDER=true', 'EM_EXTENDER=false', d)}"

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
