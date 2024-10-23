require ccsp_common_bananapi.inc

FILESEXTRAPATHS_prepend := "${THISDIR}/files:${THISDIR}/${PN}:"

SRC_URI += " file://0001-RDKBACCL-403-RDKBDEV-2853-Bringup-onewifi-in-referen.patch;apply=no "

do_bananapi_patches() {
    cd ${S}
    if [ ! -e bananapi_patch_applied ]; then
        bbnote "Patching 0001-RDKBACCL-403-RDKBDEV-2853-Bringup-onewifi-in-referen.patch"
        patch -p1 < ${WORKDIR}/0001-RDKBACCL-403-RDKBDEV-2853-Bringup-onewifi-in-referen.patch
    touch bananapi_patch_applied
    fi
}

addtask bananapi_patches after do_unpack before do_compile

DEPENDS_append = " mesh-agent "

CFLAGS_append = " -DWIFI_HAL_VERSION_3 -Wno-unused-function "
LDFLAGS_append = " -ldl"
CFLAGS_append_aarch64 = " -Wno-error "

SRC_URI += " \
    file://checkwifi.sh \
    file://onewifi_pre_start.sh \
    file://wifi_defaults.txt \
"
do_install_append(){
    install -d ${D}/nvram 
    install -m 777 ${WORKDIR}/checkwifi.sh ${D}/usr/ccsp/wifi/
    install -m 777 ${WORKDIR}/onewifi_pre_start.sh ${D}/usr/ccsp/wifi/
    install -m 644 ${WORKDIR}/wifi_defaults.txt ${D}/nvram/
}

FILES_${PN} += " \
    ${prefix}/ccsp/wifi/checkwifi.sh \
    ${prefix}/ccsp/wifi/onewifi_pre_start.sh \
    /usr/bin/wifi_events_consumer \
    /nvram/wifi_defaults.txt \
"
