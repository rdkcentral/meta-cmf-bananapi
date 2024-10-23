include ccsp_common_bananapi.inc
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI_append += "file://test.patch;apply=no "


do_bananapi_patches() {
    cd ${S}
    if [ ! -e bananapi_patch_applied ]; then
        bbnote "Patching BPI-ccsp-p-and-m-changes.patch"
        patch -p1 < ${WORKDIR}/test.patch
    touch bananapi_patch_applied
    fi
}

addtask bananapi_patches after do_unpack before do_compile
