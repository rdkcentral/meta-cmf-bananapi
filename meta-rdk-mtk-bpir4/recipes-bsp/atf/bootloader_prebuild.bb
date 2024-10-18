DESCRIPTION = "prebuild bl2.img and fip.bin inclusion"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

COMPATIBLE_MACHINE  = "^filogic$"

inherit deploy

PROVIDES += "atf_bootloader_prebuild"

SRC_URI = "file://bpi-r4_sdmmc_bl2.img\
           file://bpi-r4_sdmmc_fip.bin\
           file://bpir4_sd_image_creater.sh\
          "

do_deploy() {
        mkdir -p ${DEPLOYDIR}/atf/
        install -m 0644 ${WORKDIR}/bpi-r4_sdmmc_bl2.img ${DEPLOYDIR}/atf/
        install -m 0644 ${WORKDIR}/bpi-r4_sdmmc_fip.bin ${DEPLOYDIR}/atf/
        install -m 0777 ${WORKDIR}/bpir4_sd_image_creater.sh ${DEPLOYDIR}/
}
addtask do_deploy after do_install

