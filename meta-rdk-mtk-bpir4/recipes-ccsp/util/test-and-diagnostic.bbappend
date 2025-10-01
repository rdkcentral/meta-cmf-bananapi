include recipes-ccsp/ccsp/ccsp_common_bananapi.inc

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
SRC_URI += "file://SpeedReference.sh"

do_install:append () {
       install -m 755 ${UNPACKDIR}/SpeedReference.sh ${D}/usr/ccsp/tad/speedtest.sh
       install -m 0755 ${S}/scripts/boot_mode.sh ${D}/usr/ccsp/tad/boot_mode.sh
}
