# Only install specific firmware packages
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"



# Define only the packages we need

PACKAGES =+ " \
    ${PN}-bcm-bt \
    ${PN}-brcm \
    ${PN}-rtl-bt \
"



# Specify files for each package

FILES:${PN}-bcm-bt = " \
    ${nonarch_base_libdir}/firmware/brcm/BCM* \
"



FILES:${PN}-brcm = " \
    ${nonarch_base_libdir}/firmware/brcm/* \
"



FILES:${PN}-rtl-bt = " \
    ${nonarch_base_libdir}/firmware/rtl_bt/* \
"



# Dependencies
RDEPENDS:${PN}-bcm-bt += "${PN}-brcm"



# Remove all other firmware packages

do_install:append() {
    # Remove everything except brcm and rtl_bt directories
    find ${D}${nonarch_base_libdir}/firmware -mindepth 1 -maxdepth 1 \
        ! -name 'brcm' ! -name 'rtl_bt' -exec rm -rf {} +
}



# Update RRECOMMENDS to include only what we need
RRECOMMENDS:${PN}-nonfreefirmware = "\
    ${PN}-bcm-bt \
    ${PN}-brcm \
    ${PN}-rtl-bt \
"
