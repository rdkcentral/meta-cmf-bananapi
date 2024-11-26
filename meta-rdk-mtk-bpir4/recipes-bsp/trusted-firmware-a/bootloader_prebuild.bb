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
RDEPENDS_${PN}-dev = ""

SRC_URI = "https://artifactory.rdkcentral.com/artifactory/RDKB-Platform/BPI-R4/uboot-2024.04/bpi-r4_sdmmc_bl2.img;name=bl2\
           https://artifactory.rdkcentral.com/artifactory/RDKB-Platform/BPI-R4/uboot-2024.04/bpi-r4_sdmmc_fip.bin;name=fip\
           https://artifactory.rdkcentral.com/artifactory/RDKB-Platform/BPI-R4/uboot-2024.04/bpir4_sd_image_creater.sh;name=sdimg\
          "

SRC_URI[bl2.sha256sum]= "7af8092bc993241f44013c28894739ceb9bdb93bab593d15cc10e2e68e57a349"
SRC_URI[fip.sha256sum] = "e32aa5b1d5aca78765703f8544386fb6c294385ae120c272a863d46a599339e3"
SRC_URI[sdimg.sha256sum] = "d6747c81c8330b4f37bae34fdff1480c548f3bbe5f3fa41536907d97df89bc83"

do_deploy() {
        mkdir -p ${DEPLOYDIR}/atf/
        install -m 0644 ${WORKDIR}/bpi-r4_sdmmc_bl2.img ${DEPLOYDIR}/atf/
        install -m 0644 ${WORKDIR}/bpi-r4_sdmmc_fip.bin ${DEPLOYDIR}/atf/
        install -m 0777 ${WORKDIR}/bpir4_sd_image_creater.sh ${DEPLOYDIR}/
}
addtask do_deploy after do_install
