# TODO: Verify license -- it is Silabs specific
DESCRIPTION = "Co-Processor Communication Daemon"
LICENSE = "CLOSED"
LIC_FILES_CHKSUM = "file://LICENSE;md5=5e588136d392e8e0e36bd310e9ca0ab3"
SRC_URI = "git://github.com/SiliconLabs/cpc_daemon;protocol=https;name=cpc-daemon;branch=main"
PR = "r0"
# Tag v4.4.1
SRCREV_cpc-daemon = "283b31aef4f32df23596b8cff1a646dd1dc442c6"
SRC_URI += "file://cpcd.service \
            file://init-iot-radio.sh \
            file://cpcd_monitor.cpp \
            file://cpcd-monitor.service \
"
DEPENDS += "mbedtls systemd"
RDEPENDS_${PN} += "systemd"
S = "${WORKDIR}/git"
inherit cmake pkgconfig
EXTRA_OECMAKE += "-DUSE_LEGACY_GPIO_SYSFS=TRUE \
"
# Build cpcd_monitor app
do_compile_append() {
    cd ${B}
    export CXXFLAGS="${CXXFLAGS} -I${STAGING_INCDIR}/systemd"
    export LDFLAGS="${LDFLAGS} -L${STAGING_LIBDIR}"
    ${CXX} ${CXXFLAGS} \
        -I${S}/lib \
        ${WORKDIR}/cpcd_monitor.cpp \
        -o cpcd_monitor \
        -L${B}/ \
        -lcpc \
        -lpthread \
        -lsystemd \
        ${LDFLAGS}
}
do_install_append() {
   install -d ${D}${bindir}
   install -m 0755 ${B}/cpcd_monitor ${D}${bindir}
   install -d ${D}${systemd_unitdir}/system
   install -m 0644 ${WORKDIR}/cpcd.service ${D}${systemd_unitdir}/system/cpcd.service
   install -m 0644 ${WORKDIR}/cpcd-monitor.service ${D}${systemd_unitdir}/system/cpcd-monitor.service
   install -d ${D}/${bindir}
   install -m 0755 ${WORKDIR}/init-iot-radio.sh ${D}${bindir}/
}
FILES_${PN} += "${systemd_unitdir}/system/"
FILES_${PN} += "${bindir}/init-iot-radio.sh"
FILES_${PN} += "${bindir}/cpcd_monitor"
inherit systemd
SYSTEMD_SERVICE_${PN} = "cpcd.service"
SYSTEMD_AUTO_ENABLE = "enable"
