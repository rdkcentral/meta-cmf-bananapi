FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += " file://0001-RDKBACCL-404-RDKBDEV-2853-Bringup-onewifi-in-referen.patch;apply=no "

do_bananapi_patches() {
    cd ${S}
    cd ..
    if [ ! -e bananapi_patch_applied ]; then
        bbnote "0001-RDKBACCL-404-RDKBDEV-2853-Bringup-onewifi-in-referen.patch"
        patch -p1 < ${WORKDIR}//0001-RDKBACCL-404-RDKBDEV-2853-Bringup-onewifi-in-referen.patch
    touch bananapi_patch_applied
    fi
}

addtask bananapi_patches after do_unpack before do_compile

CFLAGS_append = " -D_PLATFORM_BANANAPI_R4_  -DBANANA_PI_PORT "
CFLAGS_append_kirkstone = " -fcommon"
EXTRA_OECONF_append = " ${@bb.utils.contains('DISTRO_FEATURES', 'OneWifi', ' ONE_WIFIBUILD=true ', '', d)}"
EXTRA_OECONF_append = " ${@bb.utils.contains('DISTRO_FEATURES', 'OneWifi', ' BANANA_PI_PORT=true ', '', d)}"
