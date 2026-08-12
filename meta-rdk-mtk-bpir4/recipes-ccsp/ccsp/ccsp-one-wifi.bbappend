require ccsp_common_bananapi.inc

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:remove = "${CMF_GIT_ROOT}/rdkb/components/opensource/ccsp/OneWifi;protocol=${CMF_GIT_PROTOCOL};branch=${CMF_GIT_BRANCH};name=OneWifi"
SRC_URI = "git://github.com/rdkcentral/OneWifi.git;protocol=https;branch=develop;name=OneWifi"
SRCREV_OneWifi = "4bc321930ccdacad095b161cf9fb6a2a9e14a527"
DEPENDS:append = " mesh-agent "
DEPENDS:remove = " opensync "
DEPENDS += " ${@bb.utils.contains('DISTRO_FEATURES', 'EasyMesh', ' rdk-wifi-libhostap ', '', d)}"

CFLAGS:append = " -DWIFI_HAL_VERSION_3 -Wno-unused-function "
LDFLAGS:append = " -ldl"
CFLAGS:append:aarch64 = " -Wno-error "

EXTRA_OECONF:append = " ${@bb.utils.contains('DISTRO_FEATURES', 'EasyMesh', ' --enable-em-app ', '', d)}"
CFLAGS:append = " ${@bb.utils.contains('DISTRO_FEATURES', 'EasyMesh', ' -DEASY_MESH_NODE ', '', d)}"
CFLAGS:append = " -DFEATURE_SINGLE_PHY"

EXTRA_OECONF:append = " ${@bb.utils.contains('DISTRO_FEATURES', 'sta_manager', 'ONEWIFI_STA_MGR_APP_SUPPORT=true', 'ONEWIFI_STA_MGR_APP_SUPPORT=false', d)}"
CFLAGS:append = " ${@bb.utils.contains('DISTRO_FEATURES', 'sta_manager', '-DONEWIFI_STA_MGR_APP_SUPPORT', '', d)}"

EXTRA_OECONF:remove = " ${@bb.utils.contains('DISTRO_FEATURES', 'EasyMesh', ' ONEWIFI_CAC_APP_SUPPORT=true ', '', d)}"
CFLAGS:remove = " ${@bb.utils.contains('DISTRO_FEATURES', 'EasyMesh', ' -DONEWIFI_CAC_APP_SUPPORT -DONEWIFI_DB_SUPPORT  ', '', d)}"

CFLAGS:append = " ${@bb.utils.contains('DISTRO_FEATURES', 'generic_mlo', ' -DCONFIG_GENERIC_MLO ', '', d)}"

EXTRA_OECONF:append = " ONEWIFI_CSI_APP_SUPPORT=true"
EXTRA_OECONF:append = " ONEWIFI_MOTION_APP_SUPPORT=true"
EXTRA_OECONF:append = " ONEWIFI_HARVESTER_APP_SUPPORT=true"
EXTRA_OECONF:append = " ONEWIFI_ANALYTICS_APP_SUPPORT=true"
EXTRA_OECONF:append = " ONEWIFI_LEVL_APP_SUPPORT=true"
EXTRA_OECONF:append = " ONEWIFI_WHIX_APP_SUPPORT=true"
EXTRA_OECONF:append = " ONEWIFI_BLASTER_APP_SUPPORT=true"

SRC_URI += " \
    file://checkwifi.sh \
    ${@bb.utils.contains('DISTRO_FEATURES', 'EasyMesh', bb.utils.contains('DISTRO_FEATURES', 'em_extender', 'file://onewifi_pre_start_em_ext.sh ','file://onewifi_pre_start_em_ctrl.sh ', d), 'file://onewifi_pre_start.sh ', d)} \
    file://wifi_defaults.txt \
"
do_install:append(){
    install -m 777 ${UNPACKDIR}/checkwifi.sh ${D}/usr/ccsp/wifi/
    install -m 777 ${UNPACKDIR}/onewifi_pre_*.sh ${D}/usr/ccsp/wifi/onewifi_pre_start.sh
    install -m 644 ${UNPACKDIR}/wifi_defaults.txt ${D}/usr/ccsp/wifi/
}

FILES:${PN} += " \
    ${prefix}/ccsp/wifi/checkwifi.sh \
    ${prefix}/ccsp/wifi/onewifi_pre_start.sh \
    /usr/bin/wifi_events_consumer \
    /usr/ccsp/wifi/wifi_defaults.txt \
    /usr/lib/libwifi* \
"
