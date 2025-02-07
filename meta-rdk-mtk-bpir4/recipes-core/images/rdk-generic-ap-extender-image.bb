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
