require ccsp_common_bananapi.inc

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

export PLATFORM_BANANAPI = "true"

SRC_URI_remove = "${CMF_GIT_ROOT}/rdkb/components/opensource/ccsp/OneWifi;protocol=${CMF_GIT_PROTOCOL};branch=${CMF_GIT_BRANCH};name=OneWifi"
SRC_URI += "git://github.com/bsomanath/OneWifi.git;protocol=https;branch=RDKBWIFI-388-wps;name=OneWifi"
SRCREV_OneWifi = "d4f4e1cc8b1334248de0951c7ae5e9f4b43e9cd1"

SRC_URI_remove += "git://github.com/rdk-gdcs/lan_web.git;protocol=https;branch=main_branch_multiap_update;name=lan_web;destsuffix=lan_web"
CFLAGS_append = " -DFEATURE_SINGLE_PHY"
# Extender WPS onboarding. Gateway builds get the controller macro instead.
CFLAGS_append = " ${@bb.utils.contains('DISTRO_FEATURES', 'em_extender', bb.utils.contains('DISTRO_FEATURES', 'em_wps_support', ' -DUWM_EXT_WPS_SUPPORT ', '', d), '', d)}"
CFLAGS_append = " ${@bb.utils.contains('DISTRO_FEATURES', 'em_extender', '', bb.utils.contains('DISTRO_FEATURES', 'em_wps_support', ' -DUWM_CTRL_WPS_SUPPORT ', '', d), d)}"
CFLAGS_remove = " -DONEWIFI_MULTIAP_APP_SUPPORT"
EXTRA_OECONF_remove = " ONEWIFI_MULTIAP_APP_SUPPORT=true"

EXTRA_OECONF_append = " ${@bb.utils.contains('DISTRO_FEATURES', 'OneWifi', ' PLATFORM_BANANAPI=true ', '', d)}"
SRC_URI += " \
    file://checkwifi.sh \
    file://mesh_aclmac.sh \
    file://mesh_setip.sh \
    file://meshapcfg.sh \
    file://handle_mesh \
    file://mesh_status.sh \
    ${@bb.utils.contains('DISTRO_FEATURES', 'EasyMesh', bb.utils.contains('DISTRO_FEATURES', 'em_extender', 'file://onewifi_pre_start_em_ext.sh ','file://onewifi_pre_start_em_ctrl.sh ', d), 'file://onewifi_pre_start.sh ', d)} \
    file://wifi_defaults.txt \
"

do_compile_prepend() {
    mkdir -p ${S}/../lan_web/
    touch ${S}/../lan_web/multiap_stub_removed
}

# RDKB-64575 moved these scripts out of OneWifi. This layer's OneWifi
# recipe still installs them when meshwifi is enabled.
do_install_prepend() {
    install -d ${S}/scripts
    for s in mesh_aclmac.sh mesh_setip.sh meshapcfg.sh handle_mesh mesh_status.sh; do
        if [ ! -f ${S}/scripts/$s ]; then
            install -m 755 ${WORKDIR}/$s ${S}/scripts/$s
        fi
    done
}

do_install_append(){
    install -m 755 ${WORKDIR}/checkwifi.sh ${D}/usr/ccsp/wifi/
    install -m 755 ${WORKDIR}/onewifi_pre_*.sh ${D}/usr/ccsp/wifi/onewifi_pre_start.sh 
    install -m 644 ${WORKDIR}/wifi_defaults.txt ${D}/usr/ccsp/wifi/
}

FILES_${PN} += " \
    ${prefix}/ccsp/wifi/checkwifi.sh \
    ${prefix}/ccsp/wifi/onewifi_pre_start.sh \
    /usr/bin/wifi_events_consumer \
    /usr/ccsp/wifi/wifi_defaults.txt \
    /usr/lib/libwifi* \
"
