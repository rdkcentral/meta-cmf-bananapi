include ccsp_common_bananapi.inc

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

CFLAGS:append  = " ${@bb.utils.contains('DISTRO_FEATURES', 'rdkb_wan_manager', '-DFEATURE_RDKB_WAN_MANAGER', '', d)}"
CFLAGS:append  += " ${@bb.utils.contains('DISTRO_FEATURES', 'dhcp_manager', '-DFEATURE_RDKB_DHCP_MANAGER', '', d)}"

SRC_URI:append = " \
    file://0001_CPU_Utilisation_and_RNDIS_changes.patch \
"
