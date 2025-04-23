require ccsp_common_bananapi.inc

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_remove = "${CMF_GIT_ROOT}/rdkb/components/opensource/ccsp/OneWifi;protocol=${CMF_GIT_PROTOCOL};branch=${CMF_GIT_BRANCH};name=OneWifi"
SRC_URI = "git://github.com/rdkcentral/OneWifi.git;protocol=https;branch=develop;name=OneWifi"
SRCREV_OneWifi = "3962d0b1f141bc1f00ef81ff25c2a36bcd5cf4e2"
DEPENDS_append = " mesh-agent "
DEPENDS_remove = " opensync "
DEPENDS += " ${@bb.utils.contains('DISTRO_FEATURES', 'EasyMesh', ' rdk-wifi-libhostap ', '', d)}"

CFLAGS_append = " -DWIFI_HAL_VERSION_3 -Wno-unused-function "
LDFLAGS_append = " -ldl"
CFLAGS_append_aarch64 = " -Wno-error "

EXTRA_OECONF_append = " ${@bb.utils.contains('DISTRO_FEATURES', 'EasyMesh', ' --enable-em-app ', '', d)}"
CFLAGS_append = " ${@bb.utils.contains('DISTRO_FEATURES', 'EasyMesh', ' -DEASY_MESH_NODE ', '', d)}"

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
