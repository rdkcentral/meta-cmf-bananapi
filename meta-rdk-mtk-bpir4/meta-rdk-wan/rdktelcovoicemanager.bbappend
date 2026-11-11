include ccsp_common_bananapi.inc

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://fix_device_dm_taking_long_time.patch;apply=no "

do_voice_patch() {
    cd ${S}
    if [ ! -e bpi_voice_patch_applied ]; then
        bbnote "Patching fix_device_dm_taking_long_time.patch"
        patch -p1 < ${WORKDIR}/fix_device_dm_taking_long_time.patch

       touch bpi_voice_patch_applied
    fi
}
addtask voice_patch after do_unpack before do_compile

INHIBIT_PACKAGE_STRIP = "1"
