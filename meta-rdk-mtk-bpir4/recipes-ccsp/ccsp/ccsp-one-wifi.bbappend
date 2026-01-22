require ccsp_common_bananapi.inc

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_remove = "${CMF_GIT_ROOT}/rdkb/components/opensource/ccsp/OneWifi;protocol=${CMF_GIT_PROTOCOL};branch=${CMF_GIT_BRANCH};name=OneWifi"
SRC_URI = "git://github.com/rdkcentral/OneWifi.git;protocol=https;branch=develop;name=OneWifi"
SRCREV_OneWifi = "74ea1f6ca37612b13cfccba6213fe3fb06beb982"
DEPENDS_append = " mesh-agent "
DEPENDS_remove = " opensync "
DEPENDS += " ${@bb.utils.contains('DISTRO_FEATURES', 'EasyMesh', ' rdk-wifi-libhostap ', '', d)}"

CFLAGS_append = " -DWIFI_HAL_VERSION_3 -Wno-unused-function "
LDFLAGS_append = " -ldl"
CFLAGS_append_aarch64 = " -Wno-error "

EXTRA_OECONF_append = " ${@bb.utils.contains('DISTRO_FEATURES', 'EasyMesh', ' --enable-em-app ', '', d)}"
CFLAGS_append = " ${@bb.utils.contains('DISTRO_FEATURES', 'EasyMesh', ' -DEASY_MESH_NODE ', '', d)}"

EXTRA_OECONF_append = " ${@bb.utils.contains('DISTRO_FEATURES', 'sta_manager', 'ONEWIFI_STA_MGR_APP_SUPPORT=true', 'ONEWIFI_STA_MGR_APP_SUPPORT=false', d)}"
CFLAGS_append = " ${@bb.utils.contains('DISTRO_FEATURES', 'sta_manager', '-DONEWIFI_STA_MGR_APP_SUPPORT', '', d)}"

EXTRA_OECONF_remove = " ${@bb.utils.contains('DISTRO_FEATURES', 'EasyMesh', ' ONEWIFI_CAC_APP_SUPPORT=true ', '', d)}"
CFLAGS_remove = " ${@bb.utils.contains('DISTRO_FEATURES', 'EasyMesh', ' -DONEWIFI_CAC_APP_SUPPORT -DONEWIFI_DB_SUPPORT  ', '', d)}"

CFLAGS_append = " ${@bb.utils.contains('DISTRO_FEATURES', 'generic_mlo', ' -DCONFIG_GENERIC_MLO ', '', d)}"

EXTRA_OECONF_append = " ONEWIFI_CSI_APP_SUPPORT=true"
EXTRA_OECONF_append = " ONEWIFI_MOTION_APP_SUPPORT=true"
EXTRA_OECONF_append = " ONEWIFI_HARVESTER_APP_SUPPORT=true"
EXTRA_OECONF_append = " ONEWIFI_ANALYTICS_APP_SUPPORT=true"
EXTRA_OECONF_append = " ONEWIFI_LEVL_APP_SUPPORT=true"
EXTRA_OECONF_append = " ONEWIFI_WHIX_APP_SUPPORT=true"
EXTRA_OECONF_append = " ONEWIFI_BLASTER_APP_SUPPORT=true"

SRC_URI += " \
    file://checkwifi.sh \
    ${@bb.utils.contains('DISTRO_FEATURES', 'EasyMesh', bb.utils.contains('DISTRO_FEATURES', 'em_extender', 'file://onewifi_pre_start_em_ext.sh ','file://onewifi_pre_start_em_ctrl.sh ', d), 'file://onewifi_pre_start.sh ', d)} \
    file://wifi_defaults.txt \
"
do_install_append(){
    install -d ${D}/nvram 
    install -m 777 ${WORKDIR}/checkwifi.sh ${D}/usr/ccsp/wifi/
    install -m 777 ${WORKDIR}/onewifi_pre_*.sh ${D}/usr/ccsp/wifi/onewifi_pre_start.sh
    install -m 644 ${WORKDIR}/wifi_defaults.txt ${D}/nvram/
}

FILES_${PN} += " \
    ${prefix}/ccsp/wifi/checkwifi.sh \
    ${prefix}/ccsp/wifi/onewifi_pre_start.sh \
    /usr/bin/wifi_events_consumer \
    /nvram/wifi_defaults.txt \
"
