include ccsp_common_bananapi.inc
DEPENDS_remove = "hal-cm hal-moca hal-mso_mgmt hal-mta"
RDEPENDS_${PN}_remove = "hal-cm hal-moca hal-mso_mgmt hal-mta"

do_configure_prepend() {
    sed -i 's/-lcm_mgnt//g' \
        ${S}/source/Makefile.am
}
