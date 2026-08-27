FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

CFLAGS_append = " -D_PLATFORM_BANANAPI_R4_  -DBANANA_PI_PORT  -DFEATURE_SINGLE_PHY -DCONFIG_HW_CAPABILITIES "

CFLAGS_append = "${@bb.utils.contains_any('DISTRO_FEATURES', 'kernel6-12 kernel6-6' , ' -DKERNEL_6_6 ','', d)}"
CFLAGS_append = "${@bb.utils.contains('DISTRO_FEATURES', 'kernel6-12' , ' -DKERNEL_6_12 -DHOSTAPD_211_v6 ','', d)}"
CFLAGS_append = " -fcommon"
CFLAGS_remove = "-DCONFIG_MBO"
EXTRA_OECONF_append = " ${@bb.utils.contains('DISTRO_FEATURES', 'OneWifi', ' ONE_WIFIBUILD=true ', '', d)}"
EXTRA_OECONF_append = " ${@bb.utils.contains('DISTRO_FEATURES', 'OneWifi', ' BANANA_PI_PORT=true ', '', d)}"


SRC_URI += " \
  ${@bb.utils.contains('DISTRO_FEATURES', 'EasyMesh', ' file://InterfaceMap_em.json ', 'file://InterfaceMap.json ', d)} \
"

# Install InterfaceMap.json in /usr/ccsp/wifi
do_install_append() {
  install -d ${D}/usr/ccsp/wifi
  install -m 0644 ${WORKDIR}/InterfaceMa*.json ${D}/usr/ccsp/wifi/InterfaceMap.json
}

FILES_${PN} += " \
  /usr/ccsp/wifi/* \
"
