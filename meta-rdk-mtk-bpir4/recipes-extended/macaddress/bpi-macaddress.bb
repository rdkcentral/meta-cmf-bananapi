SUMMARY = "Update the MAC address"

LICENSE="Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=175792518e4ac015ab6696d16c4f607e"

inherit autotools ${@bb.utils.contains("DISTRO_FEATURES", "kirkstone", "python3native", "pythonnative", d)}  systemd

SRC_URI = "${CMF_GITHUB_ROOT}/broadband-utils;protocol=https;branch=develop"

S = "${WORKDIR}/git"
PV = "1.0.0"
SRCREV = "e2060a77127aff5c2a49cb4b5957597acb642db2"

CXXFLAGS_append = "  -DAARCH64_BUILD"
CXXFLAGS_append = "  ${@bb.utils.contains('DISTRO_FEATURES', 'EasyMesh', bb.utils.contains('DISTRO_FEATURES', 'em_extender', ' -D_EM_EXT_BUILD_ -D_EM_BUILD_ ',' -D_EM_BUILD_ ', d), ' ', d)}"


do_compile() {
	${CXX} ${S}/rdkb-bpi-mac/source/*.cpp ${LDFLAGS} ${CXXFLAGS} -I ${S}/rdkb-bpi-mac//include -o rdkb-bpi-mac
}

do_install() {
	install -d ${D}${bindir}
	install -m 0755 rdkb-bpi-mac ${D}${bindir}/rdkb-bpi-mac
}
