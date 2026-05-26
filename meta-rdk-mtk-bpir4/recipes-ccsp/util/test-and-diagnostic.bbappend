include recipes-ccsp/ccsp/ccsp_common_bananapi.inc

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI += "file://SpeedReference.sh"

do_install_append () {
       install -m 755 ${WORKDIR}/SpeedReference.sh ${D}/usr/ccsp/tad/speedtest.sh
}

DEPENDS_remove = "hal-cm hal-moca hal-mso_mgmt hal-mta"
EXTRA_OECONF_append = " --disable-mta"
