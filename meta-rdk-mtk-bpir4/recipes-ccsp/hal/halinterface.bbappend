CFLAGS_append = " -DWIFI_HAL_VERSION_3"
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://hal_interface.patch;apply=no "
#need to remove this patch once this changes merged in rdk-next
do_hal_interface_patches() {
    cd ${S}
    if [ ! -e patch_applied ]; then
        bbnote "Patching hal_interface.patch"
        patch -p1 < ${WORKDIR}/hal_interface.patch
        bbnote "Patching hal_interface.patch returned $?"
        bbplain "Patching hal_interface.patch returned $?"
        bbfatal "Patching hal_interface.patch returned $?"
        bberror "Patching hal_interface.patch returned $?"
        bbwarn "Patching hal_interface.patch returned $?"
        bbdebug "Patching hal_interface.patch returned $?"
        bbnote "Log by bbnote..."
        bbnote "Log by bbnote: file content: `cat ${WORKDIR}/wifi_hal_generic.h`"
        error_command1

       touch patch_applied
    fi
}
addtask hal_interface_patches after do_unpack before do_configure
