LDFLAGS_append = " -Wl,--no-as-needed -lm -llog4c -lrdkloggers"
inherit systemd coverity
 
SRC_URI_append = " \
        ${CMF_GIT_ROOT}/rdk/devices/raspberrypi/webpa-client;protocol=${CMF_GIT_PROTOCOL};branch=${CMF_GIT_BRANCH};destsuffix=git/devices;name=rdkbbpi \
"
SRCREV_rdkbbpi = "${AUTOREV}"
do_fetch[vardeps] += "SRCREV_rdkbbpi"
SRCREV_FORMAT .= "_rdkbbpi"
 
do_install_append () {
    install -d ${D}${systemd_unitdir}/system
    install -d ${D}${base_libdir_native}/rdk
    install -m 0644 ${S}/devices/broadband/parodus/systemd/parodus.service ${D}${systemd_unitdir}/system
    install -m 0755 ${S}/devices/broadband/parodus/scripts/parodus_start.sh ${D}${base_libdir_native}/rdk
}

SYSTEMD_SERVICE_${PN}_append = " parodus.service"
 
FILES_${PN}_append = " \
     ${systemd_unitdir}/system/parodus.service \
     ${base_libdir_native}/rdk/* \
"
