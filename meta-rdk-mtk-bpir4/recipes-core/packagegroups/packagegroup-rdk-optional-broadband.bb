SUMMARY = "RDK Optional components selected on top of Core RDKB"
LICENSE = "MIT"

PACKAGE_ARCH = "${TUNE_PKGARCH}"

inherit packagegroup

PACKAGES = "${PN}"

# Packages of the enabled optional components (see rdk-bpi.inc)
RDEPENDS:${PN} = "${RDKB_OPT_PKGS_ENABLED}"
