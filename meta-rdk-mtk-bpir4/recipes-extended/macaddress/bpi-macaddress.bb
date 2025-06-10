SUMMARY = "Update the MAC address"

LICENSE="Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=175792518e4ac015ab6696d16c4f607e"

inherit autotools ${@bb.utils.contains("DISTRO_FEATURES", "kirkstone", "python3native", "pythonnative", d)}  systemd

SRC_URI = "${CMF_GITHUB_ROOT}/broadband-utils.git;protocol=git;nobranch=1"

S = "${WORKDIR}/git"
PV = "1.0.0"
SRCREV = "10bae35768d234e969723aa51e9016f116f0870e"

CXXFLAGS_append = "  -DAARCH64_BUILD"


do_compile() {
	${CXX} ${S}/rdkb-bpi-mac/source/*.cpp ${LDFLAGS} ${CXXFLAGS} -I ${S}/rdkb-bpi-mac//include -o rdkb-bpi-mac
}

do_install() {
	install -d ${D}${bindir}
	install -m 0755 rdkb-bpi-mac ${D}${bindir}/rdkb-bpi-mac
}
