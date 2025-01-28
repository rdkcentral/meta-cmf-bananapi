FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append = " file://build_issue_fix.patch;apply=no"

do_bpi_patches() {
    cd ${S}
    if [ ! -e bpi_patch_applied ]; then
        bbnote "Patching build_issue_fix.patch"
        patch -p1 < ${WORKDIR}/build_issue_fix.patch
    touch bpi_patch_applied
    fi
}

addtask bpi_patches after do_unpack before do_compile 
CFLAGS_append = " -DWIFI_HAL_VERSION_3"
