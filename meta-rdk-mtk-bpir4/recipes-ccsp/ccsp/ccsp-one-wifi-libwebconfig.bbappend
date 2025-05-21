SRC_URI_remove = "${CMF_GIT_ROOT}/rdkb/components/opensource/ccsp/OneWifi;protocol=${CMF_GIT_PROTOCOL};branch=${CMF_GIT_BRANCH};name=libwebconfig"

SRC_URI = "git://github.com/rdkcentral/OneWifi.git;protocol=https;branch=develop;name=libwebconfig"
SRCREV_libwebconfig = "0344e5612aba5852cca332acb9667ffe5342a85e"

DEPENDS += " ${@bb.utils.contains('DISTRO_FEATURES', 'EasyMesh', ' rdk-wifi-libhostap unified-wifi-mesh-header ', '', d)}"
EXTRA_OECONF_append = " ${@bb.utils.contains('DISTRO_FEATURES', 'EasyMesh', ' --enable-easymesh ', '', d)}"
EXTRA_OECONF_append = " ${@bb.utils.contains('DISTRO_FEATURES', 'EasyMesh', ' --enable-em-app ', '', d)}"

CFLAGS += " ${@bb.utils.contains('DISTRO_FEATURES', 'EasyMesh', ' -Wno-error=maybe-uninitialized -Wno-error=unused-variable -Wno-error=unused-but-set-variable -Wno-error=incompatible-pointer-types -Wno-error=sign-compare -Wno-error -DEASY_MESH_NODE  ', '', d)}"

CFLAGS_append = " -Wno-enum-conversion"

do_compile_append() {
    oe_runmake -C source/platform
}

do_install_append() {
       oe_runmake -C source/platform DESTDIR=${D} install
      install -m 644 ${S}/include/webconfig_external_proto_easymesh.h  ${D}/usr/include/ccsp
}

FILES_${PN} += " \
    ${libdir}/libwifi_bus.so* \
"

