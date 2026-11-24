include ccsp_common_bananapi.inc
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append = " file://0001-Implement-WAN-interface-handling-for-multiple-platfo.patch"
CFLAGS_append = "${@bb.utils.contains('DISTRO_FEATURES', 'vlan_manager' , ' -DFEATURE_RDKB_VLAN_MANAGER ','', d)}"
