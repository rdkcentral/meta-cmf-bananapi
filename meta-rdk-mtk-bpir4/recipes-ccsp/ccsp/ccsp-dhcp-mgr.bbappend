include ccsp_common_bananapi.inc

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

CFLAGS_append  = " ${@bb.utils.contains('DISTRO_FEATURES', 'rdkb_wan_manager', '-DFEATURE_RDKB_WAN_MANAGER', '', d)}"
CFLAGS_append  += " ${@bb.utils.contains('DISTRO_FEATURES', 'dhcp_manager', '-DFEATURE_RDKB_DHCP_MANAGER', '', d)}"

SRC_URI_append = " \
    file://0001_CPU_Utilisation_and_RNDIS_changes.patch \
"
DEPENDS_remove = "ccsp-hotspot"
DEPENDS_remove = "hal-cm hal-moca hal-mso_mgmt hal-mta"

RDEPENDS_${PN}_remove = "hal-cm hal-moca hal-mso_mgmt hal-mta ccsp-hotspot"

do_configure_prepend() {
    sed -i 's/-lhal_moca//g; s/-lcm_mgnt//g' \
        ${S}/source/TR-181/board_sbapi/Makefile.am
    sed -i 's|#include "cm_hal.h"|#ifndef MAX_KICKSTART_ROWS\n#define MAX_KICKSTART_ROWS 10\n#endif|' \
        ${S}/source/TR-181/include/cosa_deviceinfo_apis.h
    sed -i '/#include "cm_hal.h"/d' \
        ${S}/source/TR-181/board_sbapi/cosa_x_cisco_com_devicecontrol_apis.c
    sed -i 's/#ifndef PON_GATEWAY/#if !defined(PON_GATEWAY) \&\& !defined(_PLATFORM_BANANAPI_R4_)/g' \
        ${S}/source/TR-181/board_sbapi/cosa_x_cisco_com_devicecontrol_apis.c
}
