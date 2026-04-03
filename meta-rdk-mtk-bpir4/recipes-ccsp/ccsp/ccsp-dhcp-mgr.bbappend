include ccsp_common_bananapi.inc

CFLAGS_append  = " ${@bb.utils.contains('DISTRO_FEATURES', 'rdkb_wan_manager', '-DFEATURE_RDKB_WAN_MANAGER', '', d)}"
CFLAGS_append  += " ${@bb.utils.contains('DISTRO_FEATURES', 'dhcp_manager', '-DFEATURE_RDKB_DHCP_MANAGER', '', d)}"

do_install_append() {
   sed -i 's/PsmSsp.service/& ApplySystemDefaults.service/' ${D}/lib/systemd/system/CcspDHCPMgr.service
}
