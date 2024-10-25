include ccsp_common_bananapi.inc
CFLAGS_append  = " ${@bb.utils.contains('DISTRO_FEATURES', 'rdkb_wan_manager', '-DFEATURE_RDKB_WAN_MANAGER', '', d)}"
FILESEXTRAPATHS_append := "${THISDIR}/files:"

SRC_URI_append += " \
    file://BPI-DhcpManager-changes.patch;apply=no \
"
do_bananapi_patches() {
    cd ${S}
    if [ ! -e bananapi_patch_applied ]; then
        bbnote "Patching BPI-DhcpManager-changes.patch file"
        patch -p1 < ${WORKDIR}/BPI-DhcpManager-changes.patch
        touch bananapi_patch_applied
    fi
}
addtask bananapi_patches after do_unpack before do_configure
