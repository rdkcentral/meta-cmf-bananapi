include ccsp_common_bananapi.inc

FILESEXTRAPATHS_append := "${THISDIR}/files:"

SRC_URI_append += " \
    file://BPI-startParodus-changes.patch;apply=no \
"
do_bananapi_patches() {
    cd ${S}
    if [ ! -e bananapi_patch_applied ]; then
        bbnote "Patching BPI-startParodus-changes.patch file"
        patch -p1 < ${WORKDIR}/BPI-startParodus-changes.patch
        touch bananapi_patch_applied
    fi
}
addtask bananapi_patches after do_unpack before do_configure
