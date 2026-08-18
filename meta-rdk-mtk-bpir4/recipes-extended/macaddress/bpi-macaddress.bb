SUMMARY = "Update the MAC address"

LICENSE="Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=175792518e4ac015ab6696d16c4f607e"

inherit autotools ${@bb.utils.contains_any("DISTRO_FEATURES", "kirkstone wrynose", "python3native", "pythonnative", d)}  systemd

SRC_URI = "${CMF_GITHUB_ROOT}/broadband-utils;protocol=https;branch=develop"

S = "${UNPACKDIR}/${PN}-${PV}"
PV = "1.0.0"
SRCREV = "55d70f1560fc9092c037d869aae450524b5c6ae8"

CXXFLAGS:append = "  -DAARCH64_BUILD"
CXXFLAGS:append = "  ${@bb.utils.contains_any('DISTRO_FEATURES', 'EasyMesh', bb.utils.contains_any('DISTRO_FEATURES', 'em_extender', ' -D_EM_EXT_BUILD_ -D_EM_BUILD_ ',' -D_EM_BUILD_ ', d), ' ', d)}"
do_configure[noexec] = "1"

do_compile() {
	${CXX} ${S}/rdkb-bpi-mac/source/*.cpp ${LDFLAGS} ${CXXFLAGS} -I ${S}/rdkb-bpi-mac//include -o rdkb-bpi-mac
}

do_install() {
	install -d ${D}${bindir}
	install -m 0755 rdkb-bpi-mac ${D}${bindir}/rdkb-bpi-mac
}
