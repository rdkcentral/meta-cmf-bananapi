require ccsp_common_bananapi.inc

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_remove += "git://github.com/rdk-gdcs/lan_web.git;protocol=https;branch=main_branch_multiap_update;name=lan_web;destsuffix=lan_web"
CFLAGS_append = " -DFEATURE_SINGLE_PHY"
CFLAGS_remove = " -DONEWIFI_MULTIAP_APP_SUPPORT"
EXTRA_OECONF_remove = " ONEWIFI_MULTIAP_APP_SUPPORT=true"

SRC_URI += " \
    file://checkwifi.sh \
    ${@bb.utils.contains('DISTRO_FEATURES', 'EasyMesh', bb.utils.contains('DISTRO_FEATURES', 'em_extender', 'file://onewifi_pre_start_em_ext.sh ','file://onewifi_pre_start_em_ctrl.sh ', d), 'file://onewifi_pre_start.sh ', d)} \
    file://wifi_defaults.txt \
"

do_compile_prepend() {
    mkdir -p ${S}/../lan_web/
    touch ${S}/../lan_web/multiap_stub_removed
    touch ${S}/scripts/mesh_aclmac.sh
    touch ${S}/scripts/mesh_setip.sh
    touch ${S}/scripts/meshapcfg.sh
    touch ${S}/scripts/handle_mesh
    touch ${S}/scripts/mesh_status.sh
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
