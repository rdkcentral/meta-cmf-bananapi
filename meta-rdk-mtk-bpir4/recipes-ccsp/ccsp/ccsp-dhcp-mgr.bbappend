include ccsp_common_bananapi.inc

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

CFLAGS:append  = " ${@bb.utils.contains('DISTRO_FEATURES', 'rdkb_wan_manager', '-DFEATURE_RDKB_WAN_MANAGER', '', d)}"
CFLAGS:append  += " ${@bb.utils.contains('DISTRO_FEATURES', 'dhcp_manager', '-DFEATURE_RDKB_DHCP_MANAGER', '', d)}"


SRC_URI:append:wrynose = " file://wrynose-mapt-runtime-issue.patch"
