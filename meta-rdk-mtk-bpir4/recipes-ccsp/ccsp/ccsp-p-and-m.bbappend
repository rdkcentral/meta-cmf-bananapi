include ccsp_common_bananapi.inc
SRC_URI:remove = "file://filogic-factoryReset.patch"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI:append = " file://0001-RDKCOM-5616-RDKBDEV-3470-RDKBACCL-1938-RDKBACCL-1945.patch"
SRC_URI:append = " file://0001-RDKBDEV-3469-RDKBACCL-1961-Error-flooding-in-Console.patch"

do_compile_prepend () {
    if ${@bb.utils.contains('DISTRO_FEATURES', 'feature_mapt', 'true', 'false', d)}; then
       sed -i '2i <?define FEATURE_MAPT=True?>' ${S}/config-arm/TR181-USGv2.XML
    fi
}
