include ccsp_common_bananapi.inc

CFLAGS_append = "${@bb.utils.contains('DISTRO_FEATURES', 'vlan_manager' , ' -DFEATURE_RDKB_VLAN_MANAGER ','', d)}"
