FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
CFLAGS_append += " -D_PLATFORM_BANANAPI_R4_ "
SRC_URI_append += "file://Add_interface_Changes.patch"
SRC_URI_append += "file://gw_lan_refresh.patch"
SRC_URI_append += "file://Ethernet-Lan-changes.patch"
SRC_URI_append += "file://configurable-wan-interface-ethsw.patch"
SRC_URI_append += "file://vlan-manager-integration.patch"

CFLAGS_append = "${@bb.utils.contains('DISTRO_FEATURES', 'vlan_manager' , ' -DFEATURE_RDKB_VLAN_MANAGER ','', d)}"
