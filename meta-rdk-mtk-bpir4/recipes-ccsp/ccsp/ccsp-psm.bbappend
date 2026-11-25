include ccsp_common_bananapi.inc

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " file://bbhm_def_cfg_banana.xml"

do_install:append() {
    # Config files and scripts
    install -d ${D}/usr/ccsp/config
    install -m 644 ${UNPACKDIR}/bbhm_def_cfg_banana.xml ${D}/usr/ccsp/config/bbhm_def_cfg.xml
}


