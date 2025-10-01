require ccsp_common_bananapi.inc

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"



SRC_URI:remove += "git://github.com/rdk-gdcs/lan_web.git;protocol=https;branch=main_branch_multiap_update;name=lan_web;destsuffix=lan_web"
CFLAGS:append = " -DFEATURE_SINGLE_PHY"
CFLAGS:remove = " -DONEWIFI_MULTIAP_APP_SUPPORT"
EXTRA_OECONF:remove = " ONEWIFI_MULTIAP_APP_SUPPORT=true"

EXTRA_OECONF:append = " ${@bb.utils.contains('DISTRO_FEATURES', 'OneWifi', ' PLATFORM_BANANAPI=true ', '', d)}"
SRC_URI += " \
    file://checkwifi.sh \
    ${@bb.utils.contains('DISTRO_FEATURES', 'EasyMesh', bb.utils.contains('DISTRO_FEATURES', 'em_extender', 'file://onewifi_pre_start_em_ext.sh ','file://onewifi_pre_start_em_ctrl.sh ', d), 'file://onewifi_pre_start.sh ', d)} \
    file://wifi_defaults.txt \
"

do_compile:prepend() {
    mkdir -p ${S}/../lan_web/
    touch ${S}/../lan_web/multiap_stub_removed
    touch ${S}/scripts/mesh_aclmac.sh
    touch ${S}/scripts/mesh_setip.sh
    touch ${S}/scripts/meshapcfg.sh
    touch ${S}/scripts/handle_mesh
    touch ${S}/scripts/mesh_status.sh
}

do_configure:prepend:wrynose () {
         sed -i 's/^SUBDIRS += sampleapps/#SUBDIRS += sampleapps/' ${S}/source/Makefile.am
}
do_install:append(){
    install -m 755 ${UNPACKDIR}/checkwifi.sh ${D}/usr/ccsp/wifi/
    install -m 755 ${UNPACKDIR}/onewifi_pre_*.sh ${D}/usr/ccsp/wifi/onewifi_pre_start.sh
    install -m 644 ${UNPACKDIR}/wifi_defaults.txt ${D}/usr/ccsp/wifi/
}

FILES:${PN} += " \
    ${prefix}/ccsp/wifi/checkwifi.sh \
    ${prefix}/ccsp/wifi/onewifi_pre_start.sh \
    /usr/bin/wifi_events_consumer \
    /usr/ccsp/wifi/wifi_defaults.txt \
    /usr/lib/libwifi* \
"
ERROR_QA:remove = "patch-fuzz"
WARN_QA:append = " patch-fuzz"
