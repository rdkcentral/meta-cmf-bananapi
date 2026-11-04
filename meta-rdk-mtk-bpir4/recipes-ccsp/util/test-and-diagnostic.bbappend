include recipes-ccsp/ccsp/ccsp_common_bananapi.inc

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI += "file://SpeedReference.sh"

do_install_append () {
       install -m 755 ${WORKDIR}/SpeedReference.sh ${D}/usr/ccsp/tad/speedtest.sh
       install -m 0755 ${S}/scripts/boot_mode.sh ${D}/usr/ccsp/tad/boot_mode.sh
}
