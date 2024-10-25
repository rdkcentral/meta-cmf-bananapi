include ccsp_common_bananapi.inc
export PLATFORM_BANANAPIR4_ENABLED="yes"

FILES_${PN} += "/usr/bin/gw_prov_utopia"

FILESEXTRAPATHS_append := "${THISDIR}/files:"
SRC_URI_append += " \
    file://BPI-GwProvApp-changes.patch;apply=no \
"
do_bananapi_patches() {
    cd ${S}
    if [ ! -e bananapi_patch_applied ]; then
        bbnote "Patching BPI-GwProvApp-changes.patch file"
        patch -p1 < ${WORKDIR}/BPI-GwProvApp-changes.patch
        touch bananapi_patch_applied
    fi
}
addtask bananapi_patches after do_unpack before do_configure
