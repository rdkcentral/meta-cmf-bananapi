SUMMARY = "RDK-core tier-three optinal components"
LICENSE = "MIT"


PACKAGE_ARCH = "${TUNE_PKGARCH}"

inherit packagegroup

PACKAGES = "${PN}"

RDEPENDS:packagegroup-rdk-core-tier-three-broadband:append = " \
            packagegroup-rdk-core-tier-two-broadband \
            usp-pa \
            dsm \
            dobby \
            "
