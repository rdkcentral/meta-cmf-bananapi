DESCRIPTION = "HAL Firmware Upgrade for BPI"
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI:remove = "git://git01.mediatek.com/filogic/rdk-b/rdkb_hal;branch=master;protocol=https;name=fwupgradehal \
           file://LICENSE;subdir=git \
          "
SRC_URI:append = "git://github.com/rdkcentral/rdkb-hal-bpi;branch=develop;protocol=https;name=fwupgradehal \
           file://start_cron.sh \
                "
LIC_FILES_CHKSUM = "file://../../LICENSE;md5=3b83ef96387f14655fc854ddc3c6bd57"

SRCREV_fwupgradehal = "b65af992cd74ddb7335419b7e8bf3ea84b3dd7bd"
do_install:append () {
         install -d ${D}${bindir}
        install -v -m 0755 ${UNPACKDIR}/start_cron.sh ${D}${bindir}/start_cron
}
FILES:${PN} += "${bindir}/start_cron"
DEPENDS:append += " cjson "
RDEPENDS:${PN}:append = " cjson "
CFLAGS:append = "-I${STAGING_INCDIR}/cjson "
LDFLAGS += "-lcjson"
S = "${WORKDIR}/git/source/fwupgrade"
DEPENDS += " rdkb-halif-fwupgrade"
