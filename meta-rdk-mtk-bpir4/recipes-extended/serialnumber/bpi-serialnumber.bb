SUMMARY = "Update the serial number"

LICENSE="Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=175792518e4ac015ab6696d16c4f607e"

inherit autotools ${@bb.utils.contains_any("DISTRO_FEATURES", "kirkstone scarthgap", "python3native", "pythonnative", d)}  systemd

SRC_URI = "${CMF_GITHUB_ROOT}/broadband-utils;protocol=https;branch=develop"

S = "${WORKDIR}/git"
PV = "1.0.0"
SRCREV = "d7510271e6860402dd6ecc30e50ebe530d7969bf"

CFLAGS:append += " -DAARCH64_BUILD"

do_compile() {
	${CC} ${S}/rdkmmap/source/*.c ${LDFLAGS} ${CFLAGS} -I ${S}/rdkmmap/include -o rdkmmap
}

do_install() {
	install -d ${D}${bindir}
	install -m 0755 rdkmmap ${D}${bindir}/rdkmmap
#	install -D -m 0644 ${S}/rdkmmap/rdkmmap.service ${D}${systemd_unitdir}/system/rdkmmap.service
}

#SYSTEMD_SERVICE_${PN} += " rdkmmap.service"

#FILES_${PN}:append = "${systemd_unitdir}/system/rdkmmap.service"

