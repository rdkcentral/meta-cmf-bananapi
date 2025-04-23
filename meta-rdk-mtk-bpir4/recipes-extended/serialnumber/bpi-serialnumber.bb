SUMMARY = "Update the serial number"

LICENSE="Apache-2.0"
LIC_FILES_CHKSUM = "file://rdkmmap/LICENSE;md5=86d3f3a95c324c9479bd8986968f4327"

inherit autotools ${@bb.utils.contains("DISTRO_FEATURES", "kirkstone", "python3native", "pythonnative", d)}  systemd

SRC_URI = "git://github.com/rdkcentral/broadband-utils.git;branch=rdkbserial;protocol=https;"

S = "${WORKDIR}/git"
SRCREV = "${AUTOREV}"

CFLAGS_append += " -DAARCH64_BUILD"

do_compile() {
	${CC} ${S}/rdkmmap/source/*.c ${LDFLAGS} ${CFLAGS} -I ${S}/rdkmmap/include -o rdkmmap
}

do_install() {
	install -d ${D}${bindir}
	install -m 0755 rdkmmap ${D}${bindir}/rdkmmap
}
