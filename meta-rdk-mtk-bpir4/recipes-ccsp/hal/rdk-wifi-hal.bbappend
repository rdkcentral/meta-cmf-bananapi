SRC_URI:remove = "git://github.com/rdkcentral/rdk-wifi-hal.git;protocol=https;branch=main;name=rdk-wifi-hal"

SRC_URI += "git://github.com/rdkcentral/rdk-wifi-hal.git;protocol=https;branch=develop;name=rdk-wifi-hal"
SRCREV_rdk-wifi-hal = "63e8633ea7d4bb5dd77cc987086619517256af26"

CFLAGS:append = " -D_PLATFORM_BANANAPI_R4_  -DBANANA_PI_PORT  -DFEATURE_SINGLE_PHY -DCONFIG_HW_CAPABILITIES "

CFLAGS:append = " ${@bb.utils.contains('DISTRO_FEATURES', 'generic_mlo', ' -DCONFIG_GENERIC_MLO -DCONFIG_MLO ', '', d)}"
CFLAGS:append = "${@bb.utils.contains_any('DISTRO_FEATURES', 'kernel6-12 kernel6-6' , ' -DKERNEL_6_6 ','', d)}"
CFLAGS:append = " ${@bb.utils.contains('DISTRO_FEATURES', 'EasyMesh', ' -DEASY_MESH_NODE  ', '', d)}"

CFLAGS:append_kirkstone = " -fcommon"
CFLAGS:remove = "-DCONFIG_MBO"
EXTRA_OECONF:append = " ${@bb.utils.contains('DISTRO_FEATURES', 'OneWifi', ' ONE_WIFIBUILD=true ', '', d)}"
EXTRA_OECONF:append = " ${@bb.utils.contains('DISTRO_FEATURES', 'OneWifi', ' BANANA_PI_PORT=true ', '', d)}"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
  ${@bb.utils.contains('DISTRO_FEATURES', 'EasyMesh', ' file://InterfaceMap_em.json ', 'file://InterfaceMap.json ', d)} \
  ${@bb.utils.contains('DISTRO_FEATURES', 'EasyMesh', bb.utils.contains('DISTRO_FEATURES', 'em_extender', 'file://EasymeshCfg_ext.json ','file://EasymeshCfg.json ', d), ' ', d)} \
"

# Install InterfaceMap.json in /usr/ccsp/wifi
do_install:append() {
  install -d ${D}/usr/ccsp/wifi
  install -m 0644 ${WORKDIR}/InterfaceMa*.json ${D}/usr/ccsp/wifi/InterfaceMap.json
  DISTRO_EM_ENABLED="${@bb.utils.contains('DISTRO_FEATURES','EasyMesh','true','false',d)}"
  if [ $DISTRO_EM_ENABLED = 'true' ]; then
     install -d ${D}/usr/ccsp/EasyMesh
     install -m 0644 ${WORKDIR}/Easymesh*.json  ${D}/usr/ccsp/EasyMesh/EasymeshCfg.json
  fi
}

FILES:${PN} += " \
  /usr/ccsp/wifi/* \
"

FILES:${PN}:append = "${@bb.utils.contains('DISTRO_FEATURES', 'EasyMesh', ' /usr/ccsp/EasyMesh/* ', '', d)}"
