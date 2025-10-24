SUMMARY = "Unified-wifi-mesh header files installation"
HOMEPAGE = "http://github.com/rdkcentral/unified-wifi-mesh"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=e0b1ae637439c7d6f4487fb90163c79a"

SRC_URI = "git://github.com/rdkcentral/unified-wifi-mesh.git;branch=main;protocol=https;name=Unified-wifi-mesh_header"
PV = "git${SRCPV}"
SRCREV_Unified-wifi-mesh_header = "0e441b6668a0f882cb884d63e089b8a6fbfea3f5"
SRCREV_FORMAT = "Unified-wifi-mesh_header"
S = "${WORKDIR}/git"

do_install() {
    install -d ${D}/usr/include/ccsp
    install -m 644 ${S}/inc/*  ${D}/usr/include/ccsp
}

FILES_${PN} += "/usr/include/ccsp/* "
