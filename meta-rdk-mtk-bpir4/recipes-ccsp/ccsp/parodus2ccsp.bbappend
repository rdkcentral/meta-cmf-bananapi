FILESEXTRAPATHS:prepend := "${THISDIR}/parodus2ccsp:"

SRC_URI += "\
    file://parodus_read_file.sh \
    file://parodus_create_file.sh \
"
SRC_URI:append = " \
    ${CMF_GIT_ROOT}/rdk/devices/raspberrypi/webpa-client;protocol=${CMF_GIT_PROTOCOL};branch=${CMF_GIT_BRANCH};destsuffix=git/devices;name=rdkbbpi \
"
SRCREV_rdkbbpi = "${AUTOREV}"
do_fetch[vardeps] += "SRCREV_rdkbbpi"
SRCREV_FORMAT .= "_rdkbbpi"

inherit systemd coverity

EXTRA_OECMAKE += "-DBUILD_BANANAPI_R4=ON "
 
do_install:append () {
    install -d ${D}${systemd_unitdir}/system
    install -d ${D}${base_libdir}/rdk
    install -m 0644 ${S}/devices/broadband/parodus2ccsp/systemd/webpabroadband.service ${D}${systemd_unitdir}/system
    install -m 0755 ${S}/devices/broadband/parodus2ccsp/scripts/webpa_pre_setup.sh ${D}${base_libdir}/rdk
    install -d ${D}/etc/parodus
    install -m 777 ${WORKDIR}/parodus_read_file.sh ${D}/etc/parodus/
    install -m 777 ${WORKDIR}/parodus_create_file.sh ${D}/etc/parodus/

}

SYSTEMD_SERVICE:${PN}:append = " webpabroadband.service"
 
FILES:${PN} += "${libdir}/libprivilege.so.*"
FILES:${PN}-dev += " \
    ${libdir}/libprivilege.so \
    ${libdir}/libprivilege.a \
"

FILES:${PN}:append = " \
     ${systemd_unitdir}/system/webpabroadband.service \
     ${base_libdir}/rdk/* \
     /etc/parodus/* \
     ${bindir}/webpa \
     ${exec_prefix}/ccsp \
     "
