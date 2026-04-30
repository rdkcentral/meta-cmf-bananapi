#WebPA Feature
IMAGE_INSTALL_append = " parodus parodus2ccsp rdktelcovoicemanager asterisk hal-voice-asterisk cpcd otbr-agent bluez5-bluetoothd bt-host-cpc-hci-bridge barton"

#TR069 Feature
IMAGE_INSTALL_append = " ccsp-tr069-pa"
IMAGE_INSTALL_append = " bpi-serialnumber"
IMAGE_INSTALL_append = " bpi-macaddress"


IMAGE_INSTALL_append = " rdk-speedtest-cli rdm-agent ${@bb.utils.contains('DISTRO_FEATURES', 'rrd', ' remotedebugger', " ", d)}"
#Enable required linux utils for Fwupgrade
IMAGE_INSTALL_append = " gptfdisk e2fsprogs-mke2fs util-linux util-linux-losetup coreutils"

#Router discovery tool
IMAGE_INSTALL_append = " ndisc6"

IMAGE_INSTALL_append = " rust-hello-world"

IMAGE_INSTALL_append = " gcc g++ make cmake binutils packagegroup-core-buildessential libtool automake autoconf pkgconfig gdbm rust cargo xz  go git ca-certificates  openssl openssl-engines"

IMAGE_INSTALL_append = " kernel-dev kernel-devsrc kernel-modules kmod module-init-tools bc flex bison linux-libc-headers-dev"

EXTRA_IMAGE_FEATURES += "tools-sdk"
EXTRA_IMAGE_FEATURES += "dev-pkgs"

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

IMAGE_INSTALL_remove = "${@bb.utils.contains('DISTRO_FEATURES', 'ppp-enabled', '', 'pptp-linux rp-pppoe xl2tpd', d)}"
IMAGE_INSTALL_append = "${@bb.utils.contains('DISTRO_FEATURES', 'EasyMesh',' unified-wifi-mesh unified-wifi-mesh-cli ','',d)}"
IMAGE_INSTALL_append = "${@bb.utils.contains('DISTRO_FEATURES', 'with_alsap',' ieee1905-em ','',d)}"
IMAGE_INSTALL_remove_onewifi += " mtkhnat-util"
