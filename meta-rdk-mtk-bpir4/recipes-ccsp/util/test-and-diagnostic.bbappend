include recipes-ccsp/ccsp/ccsp_common_bananapi.inc

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI += "file://SpeedReference.sh"

ENABLE_RESOURCE_OPTIMIZATION = "--enable-resourceoptimization=${@bb.utils.contains('DISTRO_FEATURES', 'resource_optimization', 'yes', 'no', d)}"
EXTRA_OECONF_append = " ${ENABLE_RESOURCE_OPTIMIZATION}"

CFLAGS_append = "${@bb.utils.contains("DISTRO_FEATURES", "resource_optimization", " -DRESOURCE_OPTIMIZATION ", " ", d)} "

do_compile_prepend () {
    if ${@bb.utils.contains('DISTRO_FEATURES', 'resource_optimization', 'true', 'false', d)}; then
        sed -i '2i <?define FEATURE_RESOURCE_OPTIMIZATION=True?>' ${S}/config/TestAndDiagnostic_arm.XML
    fi
}

do_install_append () {
       install -m 755 ${WORKDIR}/SpeedReference.sh ${D}/usr/ccsp/tad/speedtest.sh
}
