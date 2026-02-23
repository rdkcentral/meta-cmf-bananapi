include ccsp_common_bananapi.inc
DEPENDS_remove = "hal-cm"
RDEPENDS_${PN}_remove = "hal-cm"
LDFLAGS_remove = "-lcm_mgnt"

do_configure_prepend() {
    # Remove cm_hal.h include
    sed -i '/#include <ccsp\/cm_hal.h>/d' \
        ${S}/source/parodusStart/start_parodus.c

    # Remove cm_hal_InitDB() full if/else block (8 lines including closing brace)
    sed -i '/if ( cm_hal_InitDB() == 0)/{N;N;N;N;N;N;N;d}' \
        ${S}/source/parodusStart/start_parodus.c
}
