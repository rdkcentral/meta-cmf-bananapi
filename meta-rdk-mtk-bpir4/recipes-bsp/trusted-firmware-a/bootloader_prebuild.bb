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
    src_bl2 = os.path.join(d.getVar('DL_DIR'), 'bpi-r4_sdmmc_bl2.img')
    dst_bl2 = os.path.join(d.getVar('WORKDIR'), 'bpi-r4_sdmmc_bl2.img')
    shutil.copyfile(src_bl2, dst_bl2)

    src_fip = os.path.join(d.getVar('DL_DIR'), 'bpi-r4_sdmmc_fip.bin')
    dst_fip = os.path.join(d.getVar('WORKDIR'), 'bpi-r4_sdmmc_fip.bin')
    shutil.copyfile(src_fip, dst_fip)
}

do_deploy() {
        mkdir -p ${DEPLOYDIR}/atf/
        install -m 0644 ${WORKDIR}/bpi-r4_sdmmc_bl2.img ${DEPLOYDIR}/atf/
        install -m 0644 ${WORKDIR}/bpi-r4_sdmmc_fip.bin ${DEPLOYDIR}/atf/
}
addtask do_deploy after do_install
