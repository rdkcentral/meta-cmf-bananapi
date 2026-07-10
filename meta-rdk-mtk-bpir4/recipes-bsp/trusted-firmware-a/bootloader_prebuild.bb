DESCRIPTION = "Inclusion of prebuild bl2.img and fip.bin firmware"

#Made a configuration changes in firmware to load rdkb stack.
LICENSE = "CLOSED"

COMPATIBLE_MACHINE  = "^filogic$"

inherit deploy

PROVIDES= "atf_bootloader_prebuild"

#Speific to BPIR4 bootloader binary files only, nothing to build.
do_compile[noexec] = "1"
do_configure[noexec] = "1"

# also get rid of the default dependency added in bitbake.conf
# since there is no 'main' package generated (empty)
RDEPENDS:${PN}-dev = ""


python do_unpack:append() {
    import shutil, os
    src_bl2 = os.path.join(d.getVar('DL_DIR'), 'bpi-r4_sdmmc_bl2_6-6.img')
    dst_bl2 = os.path.join(d.getVar('UNPACKDIR'), 'bpi-r4_sdmmc_bl2_6-6.img')
    src_B_bl2 = os.path.join(d.getVar('DL_DIR'), 'bpi-r4_sdmmc_bl2_B_6-6.img')
    dst_B_bl2 = os.path.join(d.getVar('UNPACKDIR'), 'bpi-r4_sdmmc_bl2_B_6-6.img')
    shutil.copyfile(src_bl2, dst_bl2)
    shutil.copyfile(src_B_bl2, dst_B_bl2)

    src_fip = os.path.join(d.getVar('DL_DIR'), 'bpi-r4_sdmmc_fip_6-6.bin')
    dst_fip = os.path.join(d.getVar('UNPACKDIR'), 'bpi-r4_sdmmc_fip_6-6.bin')
    src_B_fip = os.path.join(d.getVar('DL_DIR'), 'bpi-r4_sdmmc_fip_B_6-6.bin')
    dst_B_fip = os.path.join(d.getVar('UNPACKDIR'), 'bpi-r4_sdmmc_fip_B_6-6.bin')
    shutil.copyfile(src_fip, dst_fip)
    shutil.copyfile(src_B_fip, dst_B_fip)
}

do_deploy() {
        mkdir -p ${DEPLOYDIR}/atf/
        if ${@bb.utils.contains_any('DISTRO_FEATURES', 'kernel6-6 kernel6-12', 'true', 'false', d)}; then
        echo "Deploying kernel 6.6 BL2/FIP binaries..."
        install -m 0644 ${UNPACKDIR}/bpi-r4_sdmmc_bl2_6-6.img ${DEPLOYDIR}/atf/
        install -m 0644 ${UNPACKDIR}/bpi-r4_sdmmc_bl2_B_6-6.img ${DEPLOYDIR}/atf/
        install -m 0644 ${UNPACKDIR}/bpi-r4_sdmmc_fip_6-6.bin ${DEPLOYDIR}/atf/
        install -m 0644 ${UNPACKDIR}/bpi-r4_sdmmc_fip_B_6-6.bin ${DEPLOYDIR}/atf/
    else
        echo "Deploying default BL2/FIP binaries..."
        install -m 0644 ${UNPACKDIR}/bpi-r4_sdmmc_bl2.img ${DEPLOYDIR}/atf/
        install -m 0644 ${UNPACKDIR}/bpi-r4_sdmmc_bl2_B.img ${DEPLOYDIR}/atf/
        install -m 0644 ${UNPACKDIR}/bpi-r4_sdmmc_fip.bin ${DEPLOYDIR}/atf/
        install -m 0644 ${UNPACKDIR}/bpi-r4_sdmmc_fip_B.bin ${DEPLOYDIR}/atf/
    fi
}
addtask do_deploy after do_install
