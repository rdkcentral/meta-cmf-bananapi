SUMMARY = "RDK-core tier-one optinal components"
LICENSE = "MIT"


PACKAGE_ARCH = "${TUNE_PKGARCH}"

inherit packagegroup

PACKAGES = "${PN}"

RDEPENDS:packagegroup-rdk-core-tier-one-broadband:append = " \
            ccsp-webui-jst \
            lighttpd \
            test-and-diagnostic \
            ccsp-tr069-pa \
            rdk-fwupgrade-manager \
            "
