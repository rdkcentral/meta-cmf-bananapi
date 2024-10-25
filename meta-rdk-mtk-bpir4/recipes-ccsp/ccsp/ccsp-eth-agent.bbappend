include ccsp_common_bananapi.inc

FILESEXTRAPATHS_append := "${THISDIR}/files:"
SRC_URI += " file://BPI-CcspEthAgent-changes.patch;apply=no "

do_filogic_patches_append() {
    cd ${S}
    if [ ! -e bananapi_patch_applied ]; then
        bbnote "Patching BPI-CcspEthAgent-changes.patch file"
        patch -p1 < ${WORKDIR}/BPI-CcspEthAgent-changes.patch
    touch bananapi_patch_applied
    fi
}
