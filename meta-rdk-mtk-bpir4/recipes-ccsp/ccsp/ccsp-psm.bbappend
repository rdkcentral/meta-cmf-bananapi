include ccsp_common_bananapi.inc

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append = " file://bbhm_def_cfg_banana.xml"

do_install_append() {
    # Config files and scripts
    install -d ${D}/usr/ccsp/config
    install -m 644 ${WORKDIR}/bbhm_def_cfg_banana.xml ${D}/usr/ccsp/config/bbhm_def_cfg.xml
   if ${@bb.utils.contains('DISTRO_FEATURES','rndis','true','false',d)}; then
    # RNDIS supports IPv4 only
    sed -i "/dmsb.cellularmanager.profile.default.pdptype/ s#>[^<]*<#>IPv4<#" ${D}/usr/ccsp/config/bbhm_def_cfg.xml
   fi
}


