include ccsp_common_bananapi.inc
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI:remove = "file://filogic-factoryReset.patch"

do_compile_prepend () {
    if ${@bb.utils.contains('DISTRO_FEATURES', 'feature_mapt', 'true', 'false', d)}; then
       sed -i '2i <?define FEATURE_MAPT=True?>' ${S}/config-arm/TR181-USGv2.XML
    fi
}

SRC_URI_append = " \
    file://0001-RDKBACCL-1938-DCMSetting.conf-is-empty-due-to-Config.patch \
    file://0001-RDKBDEV-3469-RDKBACCL-1961-Error-flooding-in-Console.patch \
"
