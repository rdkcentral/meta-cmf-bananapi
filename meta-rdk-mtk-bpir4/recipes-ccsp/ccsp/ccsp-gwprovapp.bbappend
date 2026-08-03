include ccsp_common_bananapi.inc
export PLATFORM_BANANAPIR4_ENABLED="yes"

FILES:${PN} += " \
    /usr/bin/gw_prov_utopia \
"
CFLAGS:append = " -I${RECIPE_SYSROOT}/usr/include/safeclib"
