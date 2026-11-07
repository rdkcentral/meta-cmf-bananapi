include ccsp_common_bananapi.inc

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append = " file://bbhm_def_cfg_banana.xml"

do_install_append() {
    # Config files and scripts
    install -d ${D}/usr/ccsp/config
    install -m 644 ${WORKDIR}/bbhm_def_cfg_banana.xml ${D}/usr/ccsp/config/bbhm_def_cfg.xml
    sed -i "/dmsb.l2net.1.Members.Eth/s/lan1 lan2 lan3/& lnet0/" ${D}/usr/ccsp/config/bbhm_def_cfg.xml
}


