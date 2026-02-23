include ccsp_common_bananapi.inc
DEPENDS_remove = "hal-cm hal-moca hal-mta ccsp-hotspot"
RDEPENDS_${PN}_remove = "hal-cm hal-moca hal-mta ccsp-hotspot"
ENABLE_HOTSPOT = "no"

do_configure_prepend() {
    # --- linker flag removal from top-level Makefile.am ---
    sed -i 's/-lhal_moca//g; s/-lcm_mgnt//g' \
        ${S}/Makefile.am

    # --- cm_hal removal ---
    sed -i 's|#include "cm_hal.h"|#ifndef MAX_KICKSTART_ROWS\n#define MAX_KICKSTART_ROWS 10\n#endif|' \
        ${S}/source/TR-181/include/cosa_deviceinfo_apis.h

    sed -i 's/#ifndef PON_GATEWAY/#if !defined(PON_GATEWAY) \&\& !defined(_PLATFORM_BANANAPI_R4_)/g' \
        ${S}/source-arm/TR-181/board_sbapi/cosa_x_cisco_com_devicecontrol_apis.c

    # --- cm_hal_oem removal ---
    sed -i '/#include "cm_hal_oem.h"/d' \
        ${S}/source/TR-181/middle_layer_src/cosa_deviceinfo_dml.c

    python3 << 'PYEOF'
import re
path = "${S}/source/TR-181/middle_layer_src/cosa_deviceinfo_dml.c"
with open(path, 'r') as f:
    content = f.read()
pattern = re.compile(
    r'(BOOL\s*\n\s*Snmpv3DHKickstart_SetParamBoolValue\s*\([^)]*\)\s*\{)'
    r'.*?'
    r'^(\})',
    re.DOTALL | re.MULTILINE
)
stub = (
    'BOOL\n'
    'Snmpv3DHKickstart_SetParamBoolValue\n'
    '(\n'
    ' ANSC_HANDLE                 hInsContext,\n'
    ' char*                       ParamName,\n'
    ' BOOL                        bValue\n'
    ' )\n'
    '{\n'
    '    /* DOCSIS SNMP kickstart not applicable to BananaPi R4 ethernet gateway */\n'
    '    (void)hInsContext; (void)ParamName; (void)bValue;\n'
    '    return FALSE;\n'
    '}'
)
new_content = pattern.sub(stub, content, count=1)
with open(path, 'w') as f:
    f.write(new_content)
print("Snmpv3DHKickstart_SetParamBoolValue stubbed out")
PYEOF

    # --- hotspot removal ---
    cat > ${S}/source/TR-181/middle_layer_src/hotspotdoc.h << 'HEADER'
#ifndef __HOTSPOTDOC_H__
#define __HOTSPOTDOC_H__
/* Hotspot removed for RDK-B core build */
#endif
HEADER

    cat > ${S}/source/TR-181/include/cosa_GRE_webconfig_apis.h << 'HEADER'
#ifndef __HOTSPOT_WEBCONFIG_PARAM_H__
#define __HOTSPOT_WEBCONFIG_PARAM_H__
/* Hotspot removed for RDK-B core build */
#endif
HEADER

    sed -i '/#include "cosa_x_cisco_com_hotspot_internal.h"/d' \
        ${S}/source/TR-181/middle_layer_src/plugin_main_apis.c
    sed -i '/#include "libHotspotApi.h"/d' \
        ${S}/source/TR-181/middle_layer_src/plugin_main_apis.c

    sed -i '/if (strcmp(subdoc, "hotspot") == 0)/,/^    }/d' \
        ${S}/source/TR-181/middle_layer_src/cosa_webconfig_api.c

    sed -i 's|"hotspot",||g' \
        ${S}/source/TR-181/middle_layer_src/cosa_webconfig_api.c
}
