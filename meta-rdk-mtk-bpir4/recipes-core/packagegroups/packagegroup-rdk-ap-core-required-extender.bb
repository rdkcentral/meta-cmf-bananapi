SUMMARY = "Custom package group for EasyMesh AP Core required components"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

PACKAGE_ARCH = "${TUNE_PKGARCH}"

inherit packagegroup

PACKAGES = "\
    packagegroup-rdk-ap-core-required-extender \
    "
#components used in EasyMesh AP extender
RDEPENDS:${PN} = "\
    ccsp-common-library \
    ccsp-common-startup \
    sysint-broadband \
    ccsp-one-wifi \
    rbus \
    ccsp-gwprovapp \
    ccsp-cr \
    ccsp-cr-ccsp \
    ccsp-dmcli \
    ccsp-dmcli-ccsp \
    rdm-agent \
    ${@bb.utils.contains('DISTRO_FEATURES', 'rrd', ' remotedebugger', " ", d)} \ 
    unified-wifi-mesh \
    ${@bb.utils.contains('DISTRO_FEATURES', 'with_alsap','ieee1905-em ','',d)} \
    bpi-macaddress \
    bpi-serialnumber \
    mount-nvram \
    e2fsprogs-mke2fs \
"
DEPENDS += " ccsp-common-library"
