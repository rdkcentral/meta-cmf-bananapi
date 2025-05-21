#WebPA Feature
IMAGE_INSTALL_append = " parodus parodus2ccsp"

#TR069 Feature
IMAGE_INSTALL_append = " ccsp-tr069-pa"
IMAGE_INSTALL_append = " bpi-serialnumber"
IMAGE_INSTALL_append = " bpi-macaddress"

#Enable required linux utils for Fwupgrade
IMAGE_INSTALL_append = " gptfdisk e2fsprogs-mke2fs"

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
IMAGE_INSTALL_append = "${@bb.utils.contains('DISTRO_FEATURES', 'EasyMesh',' unified-wifi-mesh unified-wifi-mesh-cli','',d)}"
