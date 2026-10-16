#Router discovery tool
IMAGE_INSTALL:append = " ndisc6"

inherit rdk-image

IMAGE_FEATURES:remove = "read-only-rootfs"
IMAGE_FSTYPES:remove= "tar.gz"
SYSTEMD_TOOLS = "systemd-analyze systemd-bootchart"
# systemd-bootchart doesn't currently build with musl libc
SYSTEMD_TOOLS:remove:libc-musl = "systemd-bootchart"

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
    ${@bb.utils.contains_any('DISTRO_FEATURES','kirkstone wrynose','','python-core',d)} \
    pptp-linux \
    rp-pppoe  \
    procps \
    ${@bb.utils.contains('DISTRO_FEATURES','mt76','packagegroup-filogic-mt76','',d)} \
    ${@bb.utils.contains('DISTRO_FEATURES','logan','packagegroup-filogic-logan','',d)} \
    ${@bb.utils.contains('DISTRO_FEATURES','mtk_easymesh','packagegroup-filogic-mtk-easymesh','',d)} \
    "

BB_HASH_IGNORE_MISMATCH = "1"
IMAGE_NAME[vardepsexclude] = "DATETIME"

#ESDK-CHANGES
do_populate_sdk_ext:prepend() {
    builddir = d.getVar('TOPDIR')
    if os.path.exists(builddir + '/conf/templateconf.cfg'):
        with open(builddir + '/conf/templateconf.cfg', 'w') as f:
            f.write('meta/conf\n')
}

sdk_ext_postinst:append() {
   echo "ln -s $target_sdk_dir/layers/openembedded-core/meta-rdk $target_sdk_dir/layers/openembedded-core/../meta-rdk \n" >> $env_setup_script
}

PRSERV_HOST = "localhost:0"
INHERIT += "buildhistory"
BUILDHISTORY_COMMIT = "1"


remove_unused_file() {
   for i in ${REMOVED_FILE_LIST} ; do rm -rf ${IMAGE_ROOTFS}/$i ; done
}

ROOTFS_POSTPROCESS_COMMAND:append = "remove_unused_file; "

do_filogic_gen_image(){
        if ${@bb.utils.contains('DISTRO_FEATURES','wrynose','true','false',d)}; then
                SQUASHFS_FILE_PATH="${SQUASHFS_FILE_PATH}"  # ensure exported
                if [ -z "$SQUASHFS_FILE_PATH" ]; then
        # fallback: check both possibilities
                if [ -f "${IMGDEPLOYDIR}/${PN}-${MACHINE}.bin.squashfs-xz" ]; then
                         SQUASHFS_FILE_PATH="${IMGDEPLOYDIR}/${PN}-${MACHINE}.bin.squashfs-xz"
                elif [ -f "${IMGDEPLOYDIR}/${PN}-${MACHINE}.squashfs-xz" ]; then
                         SQUASHFS_FILE_PATH="${IMGDEPLOYDIR}/${PN}-${MACHINE}.squashfs-xz"
                else
                         echo "ERROR: no squashfs file found"
                         exit 1
                fi
                fi
        fi
	if ${@bb.utils.contains('DISTRO_FEATURES','kernel_in_ubi','true','false',d)}; then
        # create sysupgrade image align to openwrt
          if ${@bb.utils.contains('DISTRO_FEATURES','wrynose','true','false',d)}; then
                # Use dynamically detected squashfs path
                SQUASHFS_FILE="${IMGDEPLOYDIR}/$(basename ${SQUASHFS_FILE_PATH})"
          fi

            rm -rf ${IMGDEPLOYDIR}/sysupgrade-${PN}-${MACHINE}
            rm -rf ${IMGDEPLOYDIR}/${PN}-${MACHINE}-sysupgrade.bin

            mkdir ${IMGDEPLOYDIR}/sysupgrade-${PN}-${MACHINE}

            cp ${DEPLOY_DIR_IMAGE}/fitImage ${IMGDEPLOYDIR}/sysupgrade-${PN}-${MACHINE}/kernel
            if ${@bb.utils.contains('DISTRO_FEATURES','wrynose','true','false',d)}; then
                cp ${SQUASHFS_FILE} ${IMGDEPLOYDIR}/sysupgrade-${PN}-${MACHINE}/root
            else
                cp ${IMGDEPLOYDIR}/${PN}-${MACHINE}.squashfs-xz ${IMGDEPLOYDIR}/sysupgrade-${PN}-${MACHINE}/root
            fi

            #if ${@bb.utils.contains_any('DISTRO_FEATURES','kernel6-6 kernel6-12','true','false',d)}; then
            #    fit-rootfs-hash-tool ${IMGDEPLOYDIR}/sysupgrade-${PN}-${MACHINE}/kernel ${IMGDEPLOYDIR}/sysupgrade-${PN}-${MACHINE}/root
            #fi
            cd ${IMGDEPLOYDIR}
            tar cvf ${PN}-${MACHINE}-sysupgrade.bin sysupgrade-${PN}-${MACHINE}
            mv ${PN}-${MACHINE}-sysupgrade.bin ${DEPLOY_DIR_IMAGE}/

            if ${@bb.utils.contains('DISTRO_FEATURES','secure_boot','true','false',d)}; then

                rm -rf ${IMGDEPLOYDIR}/sysupgrade-${PN}-${MACHINE}-sb
                rm -rf ${IMGDEPLOYDIR}/${PN}-${MACHINE}-sb-sysupgrade.bin

                mkdir ${IMGDEPLOYDIR}/sysupgrade-${PN}-${MACHINE}-sb

                cp ${DEPLOY_DIR_IMAGE}/fitImage-sb ${IMGDEPLOYDIR}/sysupgrade-${PN}-${MACHINE}-sb/kernel
                if ${@bb.utils.contains('DISTRO_FEATURES','wrynose','true','false',d)}; then
                    cp ${SQUASHFS_FILE} ${IMGDEPLOYDIR}/sysupgrade-${PN}-${MACHINE}-sb/root
                else
                    cp ${IMGDEPLOYDIR}/${PN}-${MACHINE}.squashfs-xz ${IMGDEPLOYDIR}/sysupgrade-${PN}-${MACHINE}-sb/root
                fi

                if ${@bb.utils.contains_any('DISTRO_FEATURES','kernel6-6 kernel6-12','true','false',d)}; then
                fit-rootfs-hash-tool ${IMGDEPLOYDIR}/sysupgrade-${PN}-${MACHINE}-sb/kernel ${IMGDEPLOYDIR}/sysupgrade-${PN}-${MACHINE}-sb/root
                fi

                cd ${IMGDEPLOYDIR}
                tar cvf ${PN}-${MACHINE}-sb-sysupgrade.bin sysupgrade-${PN}-${MACHINE}-sb
                mv ${PN}-${MACHINE}-sb-sysupgrade.bin ${DEPLOY_DIR_IMAGE}/
            fi
        fi
}
addtask filogic_gen_image after do_image_complete before do_populate_lic_deploy
