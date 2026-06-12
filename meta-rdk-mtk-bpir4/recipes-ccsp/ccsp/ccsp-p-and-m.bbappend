include ccsp_common_bananapi.inc
SRC_URI:remove = "file://filogic-factoryReset.patch"
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

do_compile:prepend () {
    if ${@bb.utils.contains('DISTRO_FEATURES', 'feature_mapt', 'true', 'false', d)}; then
       sed -i '2i <?define FEATURE_MAPT=True?>' ${S}/config-arm/TR181-USGv2.XML
    fi
}

SRC_URI:append = "${@bb.utils.contains('DISTRO_FEATURES', 'OneWifi', ' ', ' file://wifiagent-bridge-mode-2g-roll-back.patch', d)}"
