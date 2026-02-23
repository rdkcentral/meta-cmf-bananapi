include ccsp_common_bananapi.inc
DEPENDS_remove = "hal-cm hal-moca hal-mso_mgmt hal-mta ccsp-hotspot"
RDEPENDS_${PN}_remove = "hal-cm hal-moca hal-mso_mgmt hal-mta ccsp-hotspot"

do_configure_prepend() {
    # --- linker flag removal ---
    sed -i 's/-lhal_moca//g; s/-lcm_mgnt//g' \
        ${S}/source/TR-181/board_sbapi/Makefile.am

    # --- cm_hal removal ---
    sed -i 's|#include "cm_hal.h"|#ifndef MAX_KICKSTART_ROWS\n#define MAX_KICKSTART_ROWS 10\n#endif|' \
        ${S}/source/TR-181/include/cosa_deviceinfo_apis.h

    sed -i '/#include "cm_hal.h"/d' \
        ${S}/source/TR-181/board_sbapi/cosa_x_cisco_com_devicecontrol_apis.c

    sed -i 's/#ifndef PON_GATEWAY/#if !defined(PON_GATEWAY) \&\& !defined(_PLATFORM_BANANAPI_R4_)/g' \
        ${S}/source/TR-181/board_sbapi/cosa_x_cisco_com_devicecontrol_apis.c
}
