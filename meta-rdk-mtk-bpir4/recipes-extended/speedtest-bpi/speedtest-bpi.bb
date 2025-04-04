SUMMARY = "Command line interface for testing internet bandwidth using speedtest.net"

LICENSE="Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=86d3f3a95c324c9479bd8986968f4327"

inherit autotools ${@bb.utils.contains("DISTRO_FEATURES", "kirkstone", "python3native", "pythonnative", d)}

SRC_URI = "git://github.com/anatar818/rdk-speedtest-cli.git;branch=main;protocol=https;"

S = "${WORKDIR}/git"
SRCREV = "${AUTOREV}"

do_compile() {
	${CC} ${S}/rdk-speedtest-cli.c ${LDFLAGS} -o rdk-speedtest-bpi
}

do_install() {
	install -d ${D}${bindir}
	install -m 0755 rdk-speedtest-bpi ${D}${bindir}/speedtest-client
}

