require ccsp_common_bananapi.inc

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:remove = "${CMF_GIT_ROOT}/rdkb/components/opensource/ccsp/OneWifi;protocol=${CMF_GIT_PROTOCOL};branch=${CMF_GIT_BRANCH};name=OneWifi"
SRC_URI = "git://github.com/rdkcentral/OneWifi.git;protocol=https;branch=develop;name=OneWifi"
SRCREV_OneWifi = "0344e5612aba5852cca332acb9667ffe5342a85e"
DEPENDS:append = " mesh-agent "
DEPENDS:remove = " opensync "
DEPENDS += " ${@bb.utils.contains('DISTRO_FEATURES', 'EasyMesh', ' rdk-wifi-libhostap ', '', d)}"

CFLAGS:append = " -DWIFI_HAL_VERSION_3 -Wno-unused-function "
LDFLAGS:append = " -ldl"
CFLAGS:append_aarch64 = " -Wno-error "

EXTRA_OECONF:append = " ${@bb.utils.contains('DISTRO_FEATURES', 'EasyMesh', ' --enable-em-app ', '', d)}"
CFLAGS:append = " ${@bb.utils.contains('DISTRO_FEATURES', 'EasyMesh', ' -DEASY_MESH_NODE ', '', d)}"

EXTRA_OECONF:append = " ${@bb.utils.contains('DISTRO_FEATURES', 'sta_manager', 'ONEWIFI_STA_MGR_APP_SUPPORT=true', 'ONEWIFI_STA_MGR_APP_SUPPORT=false', d)}"
CFLAGS:append = " ${@bb.utils.contains('DISTRO_FEATURES', 'sta_manager', '-DONEWIFI_STA_MGR_APP_SUPPORT', '', d)}"

SRC_URI += " \
    file://checkwifi.sh \
    file://onewifi_pre_start.sh \
    file://wifi_defaults.txt \
"
SRC_URI:append:scarthgap = " file://msgpack_redefined_compile.patch"

do_install:append(){
    install -d ${D}/nvram 
    install -m 777 ${WORKDIR}/checkwifi.sh ${D}/usr/ccsp/wifi/
    install -m 777 ${WORKDIR}/onewifi_pre_start.sh ${D}/usr/ccsp/wifi/
    install -m 644 ${WORKDIR}/wifi_defaults.txt ${D}/nvram/
}

TARGET_CFLAGS:append = " \
    -Wno-error=address \
    -Wno-error=sign-compare \
    -Wno-error=use-after-free \
    -Wno-error=maybe-uninitialized \
    -Wno-error=format \
    -Wno-error=enum-int-mismatch \
"
FILES:${PN} += " \
    ${prefix}/ccsp/wifi/checkwifi.sh \
    ${prefix}/ccsp/wifi/onewifi_pre_start.sh \
    /usr/bin/wifi_events_consumer \
    /nvram/wifi_defaults.txt \
"
RDEPENDS:${PN} += "msgpack-c"
FILES:${PN} += "${libdir}/*.so"
FILES:${PN}-dev:remove = "${libdir}/*.so"
INSANE_SKIP:${PN} += "dev-so"

