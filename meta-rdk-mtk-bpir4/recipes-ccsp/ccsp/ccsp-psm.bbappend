include ccsp_common_bananapi.inc

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append = " file://bbhm_def_cfg_banana.xml"

do_install_append() {
    if ${@bb.utils.contains('DISTRO_FEATURES','vlan_manager','false','true',d)}; then
        # VlanInUse is not required for default bridged approach by ethagent
        sed -i "/dmsb.wanmanager.if.1.VirtualInterface.1.VlanInUse/ s/Device.X_RDK_Ethernet.VLANTermination.1//" ${WORKDIR}/bbhm_def_cfg_banana.xml
        sed -i "/dmsb.wanmanager.if.1.VirtualInterface.1.VlanCount/ s/>1</>0</" ${WORKDIR}/bbhm_def_cfg_banana.xml
    fi
    # Config files and scripts
    install -d ${D}/usr/ccsp/config
    install -m 644 ${WORKDIR}/bbhm_def_cfg_banana.xml ${D}/usr/ccsp/config/bbhm_def_cfg.xml
}


