#WebPA Feature
IMAGE_INSTALL:append = " parodus parodus2ccsp rdktelcovoicemanager asterisk hal-voice-asterisk cpcd otbr-agent bluez5-bluetoothd bt-host-cpc-hci-bridge barton"

#TR069 Feature
IMAGE_INSTALL:append = " ccsp-tr069-pa"
IMAGE_INSTALL:append = " bpi-serialnumber"
IMAGE_INSTALL:append = " bpi-macaddress"


IMAGE_INSTALL:append = " rdk-speedtest-cli rdm-agent ${@bb.utils.contains('DISTRO_FEATURES', 'rrd', ' remotedebugger', " ", d)}"
#Enable required linux utils for Fwupgrade
IMAGE_INSTALL:append = " gptfdisk e2fsprogs-mke2fs util-linux util-linux-losetup coreutils"

#Router discovery tool
IMAGE_INSTALL:append = " ndisc6"

ROOTFS_POSTPROCESS_COMMAND:append = "add_busybox_fixes; "

#Emptying the PRSERV_HOST since builds are local
PRSERV_HOST = ""

add_busybox_fixes() {
                if [  -d ${IMAGE_ROOTFS}/bin ]; then
                        cd ${IMAGE_ROOTFS}/bin/
                        rm ps
                        rm ${IMAGE_ROOTFS}${bindir}/awk
                        ln -sf  /bin/busybox.nosuid  ps
                        ln -sf  /bin/busybox.nosuid  ${IMAGE_ROOTFS}${bindir}/awk
                        cd -
                fi
}

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
                if ${@bb.utils.contains_any('DISTRO_FEATURES','kernel6-6 kernel6-12','true','false',d)}; then
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

python do_hash_rootfs (){
    deploy_path = d.getVar('IMGDEPLOYDIR', d, 1)
    PN = d.getVar('PN', d, 1)
    MACHINE = d.getVar('MACHINE')
    SQUASHFS_FILE_PATH="%s/%s-%s.bin.squashfs-xz" %(deploy_path, PN, MACHINE)
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

IMAGE_INSTALL:remove = "${@bb.utils.contains('DISTRO_FEATURES', 'ppp-enabled', '', 'pptp-linux rp-pppoe xl2tpd', d)}"
IMAGE_INSTALL:append = "${@bb.utils.contains('DISTRO_FEATURES', 'EasyMesh',' unified-wifi-mesh unified-wifi-mesh-cli ','',d)}"
IMAGE_INSTALL:append = "${@bb.utils.contains('DISTRO_FEATURES', 'with_alsap',' ieee1905-em ','',d)}"
IMAGE_INSTALL:remove_onewifi += " mtkhnat-util"
