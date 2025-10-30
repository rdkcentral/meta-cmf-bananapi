inherit rdk-image
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

#SDCARD supported Pre build bootloader
do_build[depends] += "${@bb.utils.contains('DISTRO_FEATURES','sdmmc','atf_bootloader_prebuild:do_deploy','',d)}"
ROOTFS_POSTPROCESS_COMMAND_append = "add_busybox_fixes; "

#Emptying the PRSERV_HOST since builds are local
PRSERV_HOST = ""

add_busybox_fixes() {
                if [  -d ${IMAGE_ROOTFS}/bin ]; then
                        cd ${IMAGE_ROOTFS}/bin/
                        rm ps
                        rm ../usr/bin/awk
                        ln -sf  /bin/busybox.nosuid  ps
                        ln -sf  /bin/busybox.nosuid  ${IMAGE_ROOTFS}/usr/bin/awk
                        cd -
                fi
}
IMAGE_INSTALL_remove = "${@bb.utils.contains('DISTRO_FEATURES', 'ppp-enabled', '', 'pptp-linux rp-pppoe xl2tpd', d)}"

IMAGE_FEATURES_remove = "read-only-rootfs"
IMAGE_FSTYPES_remove= "tar.gz"
SYSTEMD_TOOLS = "systemd-analyze systemd-bootchart"
# systemd-bootchart doesn't currently build with musl libc
SYSTEMD_TOOLS_remove_libc-musl = "systemd-bootchart"

DEPENDS += "cryptsetup-native fit-rootfs-hash-tool-native"

IMAGE_INSTALL += " \
    ${SYSTEMD_TOOLS} \
    ethtool \
    ebtables \
    regs \
    mii-mgr \
    mtd \
    smp \
    mtk-factory-rw \
    ${@bb.utils.contains('DISTRO_FEATURES','switch_gsw_mode','switch','',d)} \
    mtd-utils-ubifs \
    u-boot-fw-utils \
    fw-upgrade \
    init-filogic \
    mac-sec \
    mtkhnat-util \
    network-hotplug \
    libmcrypt \
    coreutils \
    util-linux-readprofile \    
    iputils \ 
    bc \
    ${@bb.utils.contains('DISTRO_FEATURES','kirkstone','','python-core',d)} \ 
    dosfstools \
    pptp-linux \
    rp-pppoe  \  
    xl2tpd \
    strongswan \
    libpcap \
    tcpdump \
    ${@bb.utils.contains('DISTRO_FEATURES','kernel6-6','linux-firmware-mt7988  fitblk','',d)} \
    ${@bb.utils.contains('DISTRO_FEATURES','kernel6-6','','perf',d)} \
    ${@bb.utils.contains('DISTRO_FEATURES','mt76','packagegroup-filogic-mt76','',d)} \
    ${@bb.utils.contains('DISTRO_FEATURES','em_extender','packagegroup-ap-extender','',d)} \
    ${@bb.utils.contains('DISTRO_FEATURES','logan','packagegroup-filogic-logan','',d)} \
    ${@bb.utils.contains('DISTRO_FEATURES','mtk_easymesh','packagegroup-filogic-mtk-easymesh','',d)} \
    ${@bb.utils.contains('DISTRO_FEATURES','emmc','e2fsprogs f2fs-tools','',d)} \
    util-linux-blkid \
    util-linux-blockdev \
    ${@bb.utils.contains('DISTRO_FEATURES','secure_boot','dmsetup','',d)} \
    ${@bb.utils.contains('DISTRO_FEATURES','efuse_tools','mtk-efuse-nl-drv mtk-efuse-nl-tool','',d)} \
    ${@bb.utils.contains('DISTRO_FEATURES','flow_offload','flowtable','',d)} \
    ${@bb.utils.contains('DISTRO_FEATURES','samba','ksmbd ksmbd-tools','',d)} \
    "
#IMAGE_INSTALL += " opensync openvswitch mesh-agent e2fsprogs "

IMAGE_INSTALL_append_mt7988 += " marvell-eth-firmware mediatek-eth-firmware "

BB_HASH_IGNORE_MISMATCH = "1"
IMAGE_NAME[vardepsexclude] = "DATETIME"
#ESDK-CHANGES
do_populate_sdk_ext_prepend() {
    builddir = d.getVar('TOPDIR')
    if os.path.exists(builddir + '/conf/templateconf.cfg'):
        with open(builddir + '/conf/templateconf.cfg', 'w') as f:
            f.write('meta/conf\n')
}

sdk_ext_postinst_append() {
   echo "ln -s $target_sdk_dir/layers/openembedded-core/meta-rdk $target_sdk_dir/layers/openembedded-core/../meta-rdk \n" >> $env_setup_script
}

PRSERV_HOST = "localhost:0"
INHERIT += "buildhistory"
BUILDHISTORY_COMMIT = "1"

require ${TOPDIR}/../meta-cmf-filogic/recipes-core/images/image-exclude-files.inc

remove_unused_file() {
   for i in ${REMOVED_FILE_LIST} ; do rm -rf ${IMAGE_ROOTFS}/$i ; done
}
ROOTFS_POSTPROCESS_COMMAND_append = "remove_unused_file; "

do_filogic_gen_image(){
	if ${@bb.utils.contains('DISTRO_FEATURES','kernel_in_ubi','true','false',d)}; then
        # create sysupgrade image align to openwrt

            rm -rf ${IMGDEPLOYDIR}/sysupgrade-${PN}-${MACHINE}
            rm -rf ${IMGDEPLOYDIR}/${PN}-${MACHINE}-sysupgrade.bin

            mkdir ${IMGDEPLOYDIR}/sysupgrade-${PN}-${MACHINE}

            cp ${DEPLOY_DIR_IMAGE}/fitImage ${IMGDEPLOYDIR}/sysupgrade-${PN}-${MACHINE}/kernel
            cp ${IMGDEPLOYDIR}/${PN}-${MACHINE}.squashfs-xz ${IMGDEPLOYDIR}/sysupgrade-${PN}-${MACHINE}/root

            if ${@bb.utils.contains('DISTRO_FEATURES','kernel6-6','true','false',d)}; then
                fit-rootfs-hash-tool ${IMGDEPLOYDIR}/sysupgrade-${PN}-${MACHINE}/kernel ${IMGDEPLOYDIR}/sysupgrade-${PN}-${MACHINE}/root
            fi
            cd ${IMGDEPLOYDIR}
            tar cvf ${PN}-${MACHINE}-sysupgrade.bin sysupgrade-${PN}-${MACHINE}
            mv ${PN}-${MACHINE}-sysupgrade.bin ${DEPLOY_DIR_IMAGE}/

        if ${@bb.utils.contains('DISTRO_FEATURES','secure_boot','true','false',d)}; then

            rm -rf ${IMGDEPLOYDIR}/sysupgrade-${PN}-${MACHINE}-sb
            rm -rf ${IMGDEPLOYDIR}/${PN}-${MACHINE}-sb-sysupgrade.bin

            mkdir ${IMGDEPLOYDIR}/sysupgrade-${PN}-${MACHINE}-sb

            cp ${DEPLOY_DIR_IMAGE}/fitImage-sb ${IMGDEPLOYDIR}/sysupgrade-${PN}-${MACHINE}-sb/kernel

            cp ${IMGDEPLOYDIR}/${PN}-${MACHINE}.squashfs-xz ${IMGDEPLOYDIR}/sysupgrade-${PN}-${MACHINE}-sb/root

            if ${@bb.utils.contains('DISTRO_FEATURES','kernel6-6','true','false',d)}; then
                fit-rootfs-hash-tool ${IMGDEPLOYDIR}/sysupgrade-${PN}-${MACHINE}-sb/kernel ${IMGDEPLOYDIR}/sysupgrade-${PN}-${MACHINE}-sb/root
            fi
            cd ${IMGDEPLOYDIR}

            tar cvf ${PN}-${MACHINE}-sb-sysupgrade.bin sysupgrade-${PN}-${MACHINE}-sb

            mv ${PN}-${MACHINE}-sb-sysupgrade.bin ${DEPLOY_DIR_IMAGE}/

        fi      

    fi

}

addtask filogic_gen_image after do_image_complete before do_populate_lic_deploy

python do_hash_rootfs (){
    deploy_path = d.getVar('IMGDEPLOYDIR', d, 1)
    PN = d.getVar('PN', d, 1)
    MACHINE = d.getVar('MACHINE', d, 1)
    SQUASHFS_FILE_PATH="%s/%s-%s.squashfs-xz" %(deploy_path, PN, MACHINE)    
    DEPLOY_DIR_IMAGE = d.getVar('DEPLOY_DIR_IMAGE', d, 1)
    SUMMARY_FILE="%s/hash-summary" %(DEPLOY_DIR_IMAGE)
    FILE_SIZE = os.path.getsize(SQUASHFS_FILE_PATH) 
    BLOCK_SIZE= int(d.getVar('NAND_PAGE_SIZE', d, 1))
    DATA_BLOCKS= FILE_SIZE / BLOCK_SIZE

    if ((FILE_SIZE % BLOCK_SIZE) != 0):
        DATA_BLOCKS = DATA_BLOCKS+1
    
    HASH_OFFSET=DATA_BLOCKS * BLOCK_SIZE
    import subprocess
    subprocess.Popen("veritysetup format --data-blocks=%d --hash-offset=%d %s %s > %s" %(DATA_BLOCKS, HASH_OFFSET, SQUASHFS_FILE_PATH, SQUASHFS_FILE_PATH, SUMMARY_FILE), shell=True)
}

addtask hash_rootfs after do_image_complete before do_filogic_gen_image

python __anonymous () {
    d.appendVarFlag('do_filogic_gen_image', 'depends', ' linux-mediatek:do_deploy')
}
