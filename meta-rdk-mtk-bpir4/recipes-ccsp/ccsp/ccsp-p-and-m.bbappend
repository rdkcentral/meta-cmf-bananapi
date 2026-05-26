include ccsp_common_bananapi.inc
SRC_URI:remove = "file://filogic-factoryReset.patch"
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

DEPENDS_remove = "hal-cm hal-moca hal-mta ccsp-hotspot"
RDEPENDS_${PN}_remove = "hal-cm hal-moca hal-mta ccsp-hotspot"
ENABLE_HOTSPOT = "no"

do_compile_prepend () {
    if ${@bb.utils.contains('DISTRO_FEATURES', 'feature_mapt', 'true', 'false', d)}; then
       sed -i '2i <?define FEATURE_MAPT=True?>' ${S}/config-arm/TR181-USGv2.XML
    fi
}

SRC_URI_append = "${@bb.utils.contains('DISTRO_FEATURES', 'OneWifi', ' ', ' file://wifiagent-bridge-mode-2g-roll-back.patch', d)}"

do_configure_prepend() {
    # --- linker flag removal ---
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

    # --- hotspot: cut libHotspotApi link dependency ---
    sed -i '/#include "cosa_x_cisco_com_hotspot_internal.h"/d' \
        ${S}/source/TR-181/middle_layer_src/plugin_main_apis.c
    sed -i '/#include "libHotspotApi.h"/d' \
        ${S}/source/TR-181/middle_layer_src/plugin_main_apis.c
    sed -i 's|"hotspot",||g' \
        ${S}/source/TR-181/middle_layer_src/cosa_webconfig_api.c

    sed -i '/wbInitializeHotspot/d' \
        ${S}/source/TR-181/middle_layer_src/cosa_webconfig_api.c

    python3 << 'PYEOF'
import re, os

S = "${S}"

# ----------------------------------------------------------------
# 1. Snmpv3DHKickstart stub (DOCSIS not applicable to BPI R4)
# ----------------------------------------------------------------
path = os.path.join(S, "source/TR-181/middle_layer_src/cosa_deviceinfo_dml.c")
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
    '    /* DOCSIS SNMP kickstart not applicable to BananaPi R4 */\n'
    '    (void)hInsContext; (void)ParamName; (void)bValue;\n'
    '    return FALSE;\n'
    '}'
)
new_content = pattern.sub(stub, content, count=1)
if new_content == content:
    print("WARNING: Snmpv3DHKickstart_SetParamBoolValue pattern not found")
else:
    with open(path, 'w') as f:
        f.write(new_content)
    print("Snmpv3DHKickstart_SetParamBoolValue stubbed out")

# ----------------------------------------------------------------
# 2. Hotspot stub headers
#    Empty guards prevent libHotspotApi link dependency while
#    ENABLE_HOTSPOT=no keeps CONFIG_CISCO_HOTSPOT undefined.
# ----------------------------------------------------------------
with open(os.path.join(S, "source/TR-181/middle_layer_src/hotspotdoc.h"), 'w') as f:
    f.write(
        "#ifndef __HOTSPOTDOC_H__\n"
        "#define __HOTSPOTDOC_H__\n"
        "/* Hotspot removed for RDK-B core build */\n"
        "#endif\n"
    )
print("hotspotdoc.h stub written")

with open(os.path.join(S, "source/TR-181/include/cosa_GRE_webconfig_apis.h"), 'w') as f:
    f.write(
        "#ifndef __HOTSPOT_WEBCONFIG_PARAM_H__\n"
        "#define __HOTSPOT_WEBCONFIG_PARAM_H__\n"
        "/* Hotspot removed for RDK-B core build */\n"
        "#endif\n"
    )
print("cosa_GRE_webconfig_apis.h stub written")

# ----------------------------------------------------------------
# 3. Stub cosa_GRE_webconfig_apis.c (source-arm)
#    This file uses hotspotparam_t/tunneldoc_t/wifi_doc_t from
#    hotspotdoc.h. Since hotspotdoc.h is now empty, this file
#    cannot compile. Replace with a no-op stub.
#    Its functions (unpackAndProcessHotspotData, freeMem_hotspot)
#    are only called via the hotspot webconfig path which is
#    already removed from cosa_webconfig_api.c.
# ----------------------------------------------------------------
gre_c = os.path.join(S, "source-arm/TR-181/board_sbapi/cosa_GRE_webconfig_apis.c")
with open(gre_c, 'w') as f:
    f.write(
        "/* BPI R4 core build: hotspot GRE webconfig not applicable.\n"
        " * Original uses hotspot types (hotspotparam_t, tunneldoc_t,\n"
        " * wifi_doc_t) from hotspotdoc.h which is stubbed in this build.\n"
        " * Callers removed via cosa_webconfig_api.c hotspot block removal.\n"
        " */\n"
    )
print("source-arm/cosa_GRE_webconfig_apis.c stubbed")

# ----------------------------------------------------------------
# 4. Remove hotspot subdoc block from cosa_webconfig_api.c
# ----------------------------------------------------------------
path = os.path.join(S, "source/TR-181/middle_layer_src/cosa_webconfig_api.c")
with open(path, 'r') as f:
    content = f.read()
pattern = re.compile(
    r'\n[ \t]+if\s*\(strcmp\s*\(\s*subdoc\s*,\s*"hotspot"\s*\)\s*==\s*0\s*\)'
    r'\s*\{[^{}]*(?:\{[^{}]*\}[^{}]*)?\}',
    re.DOTALL
)
new_content, count = pattern.subn('', content)
if count == 0:
    print("WARNING: hotspot subdoc block not found in cosa_webconfig_api.c")
else:
    with open(path, 'w') as f:
        f.write(new_content)
    print("Removed %d hotspot subdoc block(s) from cosa_webconfig_api.c" % count)

# ----------------------------------------------------------------
# 5. XfinityWiFi + CloudCapable stubs
#    These symbols come from ccsp-adv-security (not in this build).
#    ENABLE_HOTSPOT=no means CONFIG_CISCO_HOTSPOT is NOT defined,
#    so the real implementations in cosa_deviceinfo_apis_custom.c
#    are compiled out. We provide stubs here.
#    Forward declarations are inserted after the last #include so
#    the compiler knows the return types before line 169 calls them,
#    preventing the implicit-int / ANSC_STATUS type conflict.
# ----------------------------------------------------------------
path = os.path.join(S, "source/TR-181/middle_layer_src/cosa_deviceinfo_internal.c")
with open(path, 'r') as f:
    content = f.read()

forward_decls = (
    "\n\n/* BPI R4 build: forward declarations for adv-security stubs */\n"
    "ANSC_STATUS CosaDmlDiGetXfinityWiFiEnable(BOOL *pBool);\n"
    "ANSC_STATUS CosaDmlDiGetCloudCapable(BOOL *pBool);\n"
)
last_inc = list(re.finditer(r'^#include\s+[<"][^>"]+[>"]\s*$', content, re.MULTILINE))
if last_inc:
    pos = last_inc[-1].end()
    content = content[:pos] + forward_decls + content[pos:]
    print("Forward declarations inserted after last #include")
else:
    content = forward_decls + content
    print("WARNING: no #include found; forward declarations prepended")

stub_code = (
    "\n"
    "/* -------------------------------------------------------\n"
    " * BPI R4 core build stubs\n"
    " * CosaDmlDiGetXfinityWiFiEnable and CosaDmlDiGetCloudCapable\n"
    " * are normally provided by ccsp-adv-security (not in this build).\n"
    " * Without these stubs libtr181.so fails to dlopen, P&M has no\n"
    " * TR-181 data model, and brlan0 never gets its IP address.\n"
    " * ------------------------------------------------------- */\n"
    "__attribute__((weak)) ANSC_STATUS\n"
    "CosaDmlDiGetXfinityWiFiEnable(BOOL *pBool)\n"
    "{\n"
    "    if (pBool) *pBool = FALSE;\n"
    "    return ANSC_STATUS_SUCCESS;\n"
    "}\n"
    "\n"
    "__attribute__((weak)) ANSC_STATUS\n"
    "CosaDmlDiGetCloudCapable(BOOL *pBool)\n"
    "{\n"
    "    if (pBool) *pBool = FALSE;\n"
    "    return ANSC_STATUS_SUCCESS;\n"
    "}\n"
)
with open(path, 'w') as f:
    f.write(content + stub_code)
print("XfinityWiFi and CloudCapable stubs written with forward declarations")

PYEOF
}
