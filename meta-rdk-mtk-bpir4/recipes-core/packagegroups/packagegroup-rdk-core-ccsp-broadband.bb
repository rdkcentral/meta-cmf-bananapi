SUMMARY = "RDK Common Core and Required components"
LICENSE = "MIT"


PACKAGE_ARCH = "${TUNE_PKGARCH}"

inherit packagegroup

PACKAGES = "${PN}"

GWPROVAPP = "${@bb.utils.contains('DISTRO_FEATURES','rdkb_wan_manager','ccsp-gwprovapp mount-nvram', '' ,d)}"

RDEPENDS:${PN} = " \
    rbus \
    commonutilities \
    ccsp-common-library \
    ccsp-common-startup \
    utopia \
    ccsp-cr \
    ccsp-cr-ccsp \
    ccsp-dmcli \
    ccsp-dmcli-ccsp \
    rdk-logger \
    remotedebugger \
    sysint-broadband \
    core-net-lib \
    ccsp-dhcp-mgr \
    ccsp-eth-agent \
    ccsp-lm-lite \
    ccsp-lm-lite-ccsp \
    ccsp-misc \
    ccsp-misc-ccsp \
    ccsp-one-wifi \
    rdk-wanmanager \
    ccsp-p-and-m \
    ccsp-p-and-m-ccsp \
    ccsp-psm \
    ccsp-psm-ccsp \
    ${GWPROVAPP} \
"

DEPENDS += " ccsp-common-library"
