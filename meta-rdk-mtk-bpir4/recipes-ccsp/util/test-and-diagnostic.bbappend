include recipes-ccsp/ccsp/ccsp_common_bananapi.inc

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
SRC_URI += "file://SpeedReference.sh"

do_install:append () {
       install -m 755 ${WORKDIR}/SpeedReference.sh ${D}/usr/ccsp/tad/speedtest.sh
}
