FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
FILESEXTRAPATHS:prepend := "${@bb.utils.contains('DISTRO_FEATURES', 'kernel6-12', '${TOPDIR}/../meta-filogic/recipes-kernel/linux/linux-mediatek-6.12/mediatek/files-6.12/drivers/base/firmware_loader/builtin:', '', d)}"

SRC_URI:append:kernel6-12 = " \
    file://airoha/EthMD32.dm.bin \
    file://airoha/EthMD32.DSP.bin \
"
PACKAGES =+ " \
    ${PN}-bcm-bt \
    ${PN}-brcm \
    ${PN}-rtl-bt \
"

FILES:${PN}-bcm-bt = " \
    ${nonarch_base_libdir}/firmware/brcm/BCM* \
"

FILES:${PN}-brcm = " \
    ${nonarch_base_libdir}/firmware/brcm/* \
"

FILES:${PN}-rtl-bt = " \
    ${nonarch_base_libdir}/firmware/rtl_bt/* \
"

# Override meta-filogic's wrong subdir path — files are flat in mediatek/
FILES:${PN}-mt7988 = " \
    ${nonarch_base_libdir}/firmware/mediatek/mt7988* \
"

RDEPENDS:${PN}-bcm-bt += "${PN}-brcm"
ALLOW_EMPTY:${PN} = "1" 

do_install:append() {
    find ${D}${nonarch_base_libdir}/firmware -mindepth 1 -maxdepth 1 \
        ! -name 'brcm' ! -name 'rtl_bt' ! -name 'airoha' ! -name 'mediatek' \
        ! -name 'LICENSE*' ! -name 'LICENCE*' ! -name 'WHENCE' \
        -exec rm -rf {} +

    rm -rf ${D}${nonarch_base_libdir}/firmware/mediatek/mt7996
    rm -rf ${D}${nonarch_base_libdir}/firmware/mediatek/mt7988
    rm -rf ${D}${nonarch_base_libdir}/firmware/mediatek/mt7996/mt7996*
    kernel6_12_ENABLED="${@bb.utils.contains('DISTRO_FEATURES','kernel6-12','true','false',d)}"
    if [ $kernel6_12_ENABLED = 'true' ]; then
          install -m 644 ${WORKDIR}/airoha/EthMD32*  ${D}${nonarch_base_libdir}/firmware/airoha
          cp -rf ${WORKDIR}/airoha/EthMD32* ${WORKDIR}/${PN}-${PV}/airoha/
          cp -rf ${WORKDIR}/airoha/EthMD32* ${TOPDIR}/firmware/airoha/
    fi
}


RRECOMMENDS:${PN} = " \
    ${PN}-bcm-bt \
    ${PN}-brcm \
    ${PN}-rtl-bt \
    ${PN}-airoha \
    ${PN}-mt7988 \
"
