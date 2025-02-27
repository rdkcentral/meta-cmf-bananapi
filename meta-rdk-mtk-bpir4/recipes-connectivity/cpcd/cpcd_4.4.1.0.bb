# TODO: Verify license -- it is Silabs specific
DESCRIPTION = "Co-Processor Communication Daemon"
LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://LICENSE;md5=5e588136d392e8e0e36bd310e9ca0ab3"
SRC_URI = "git://github.com/SiliconLabs/cpc_daemon;protocol=https;name=cpc-daemon;branch=main"
PR = "r0"
# Tag v4.4.1
SRCREV_cpc-daemon = "283b31aef4f32df23596b8cff1a646dd1dc442c6"
SRC_URI += "file://cpcd.service \
            file://cpcd.conf \
"
DEPENDS += "mbedtls systemd"
RDEPENDS_${PN} += "systemd"
S = "${WORKDIR}/git"
inherit cmake pkgconfig
EXTRA_OECMAKE += "-DUSE_LEGACY_GPIO_SYSFS=TRUE \
"
do_install_append() {
   install -d ${D}${sysconfdir}
   install -m 0644 ${WORKDIR}/cpcd.conf ${D}${sysconfdir}/cpcd.conf
   install -d ${D}${bindir}
   install -d ${D}${systemd_unitdir}/system
   install -m 0644 ${WORKDIR}/cpcd.service ${D}${systemd_unitdir}/system/cpcd.service
}
FILES_${PN} += "${systemd_unitdir}/system/"
inherit systemd
SYSTEMD_SERVICE_${PN} = "cpcd.service"
SYSTEMD_AUTO_ENABLE = "enable"
