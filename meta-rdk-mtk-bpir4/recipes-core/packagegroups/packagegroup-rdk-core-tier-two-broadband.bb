SUMMARY = "RDK-core tier-two optinal components"
LICENSE = "MIT"


PACKAGE_ARCH = "${TUNE_PKGARCH}"

inherit packagegroup

PACKAGES = "${PN}"

RDEPENDS:packagegroup-rdk-core-tier-two-broadband:append = " \
            packagegroup-rdk-core-tier-one-broadband \ 
            cpuprocanalyzer \
            crashupload \
            ${@bb.utils.contains('DISTRO_FEATURES', 'EasyMesh',' unified-wifi-mesh unified-wifi-mesh-cli ','',d)} \
            ${@bb.utils.contains('DISTRO_FEATURES', 'with_alsap',' ieee1905-em ','',d)} \
            telemetry \
            rfc \
            rdkcertconfig \
            rdk-speedtest-cli \
            memstree \
            syslog-helper \
            " 
