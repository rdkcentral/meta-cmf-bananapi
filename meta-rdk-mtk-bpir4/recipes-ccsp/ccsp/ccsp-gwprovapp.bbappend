include ccsp_common_bananapi.inc
export PLATFORM_BANANAPIR4_ENABLED="yes"

DEPENDS_remove = "hal-cm hal-moca hal-mso_mgmt hal-mta"

RDEPENDS_${PN}_remove = "hal-cm hal-moca hal-mso_mgmt hal-mta"

do_configure_prepend() {
    sed -i 's/-lcm_mgnt//g' \
        ${S}/source/Makefile.am
} 

FILES_${PN} += " \
    /usr/bin/gw_prov_utopia \
"
