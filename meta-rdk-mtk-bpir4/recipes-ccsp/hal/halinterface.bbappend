CFLAGS_append = " -DWIFI_HAL_VERSION_3"
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://hal_interface.patch;apply=no "
#need to remove this patch once this changes merged in rdk-next
do_hal_interface_patches() {
    cd ${S}
    if [ ! -e patch_applied ]; then
        bbnote "Patching hal_interface.patch"
        patch -p1 < ${WORKDIR}/hal_interface.patch

       touch patch_applied
    fi
}
addtask hal_interface_patches after do_unpack before do_configure
