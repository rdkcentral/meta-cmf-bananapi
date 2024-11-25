#WebPA Feature
IMAGE_INSTALL_append = " parodus parodus2ccsp"

#TR069 Feature
IMAGE_INSTALL_append = " ccsp-tr069-pa"

#SDCARD supported Pre build bootloader
do_build[depends] += "${@bb.utils.contains('DISTRO_FEATURES','sdmmc','atf_bootloader_prebuild:do_deploy','',d)}"

ROOTFS_POSTPROCESS_COMMAND_append = "add_busybox_fixes; "

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
