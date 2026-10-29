FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_remove = "git://github.com/rdkcentral/rdk-wifi-hal.git;protocol=https;branch=main;name=rdk-wifi-hal"
SRC_URI += "git://github.com/bsomanath/rdk-wifi-hal.git;protocol=https;branch=RDKBWIFI-388-wps;name=rdk-wifi-hal"
SRCREV_rdk-wifi-hal = "c9da674813b9e406ea3cff51e875997c4830a681"

CFLAGS_append = " -D_PLATFORM_BANANAPI_R4_  -DBANANA_PI_PORT  -DFEATURE_SINGLE_PHY -DCONFIG_HW_CAPABILITIES "
CFLAGS_append = "${@bb.utils.contains('DISTRO_FEATURES', 'em_extender', bb.utils.contains('DISTRO_FEATURES', 'em_wps_support', ' -DUWM_EXT_WPS_SUPPORT', '', d), '', d)}"

CFLAGS_append = "${@bb.utils.contains_any('DISTRO_FEATURES', 'kernel6-12 kernel6-6' , ' -DKERNEL_6_6 ','', d)}"
CFLAGS_append = "${@bb.utils.contains('DISTRO_FEATURES', 'kernel6-12' , ' -DKERNEL_6_12 -DHOSTAPD_211_V6 ','', d)}"
CFLAGS_append = " -fcommon"
EXTRA_OECONF_append = " ${@bb.utils.contains('DISTRO_FEATURES', 'OneWifi', ' ONE_WIFIBUILD=true ', '', d)}"
EXTRA_OECONF_append = " ${@bb.utils.contains('DISTRO_FEATURES', 'OneWifi', ' BANANA_PI_PORT=true ', '', d)}"


SRC_URI += " \
  ${@bb.utils.contains('DISTRO_FEATURES', 'EasyMesh', ' file://InterfaceMap_em.json ', 'file://InterfaceMap.json ', d)} \
  ${@bb.utils.contains('DISTRO_FEATURES', 'EasyMesh', bb.utils.contains('DISTRO_FEATURES', 'em_extender', 'file://EasymeshCfg_ext.json ','file://EasymeshCfg.json ', d), ' ', d)} \
"

# Install InterfaceMap.json in /usr/ccsp/wifi
do_install_append() {
  install -d ${D}/usr/ccsp/wifi
  install -m 0644 ${WORKDIR}/InterfaceMa*.json ${D}/usr/ccsp/wifi/InterfaceMap.json
  DISTRO_EM_ENABLED="${@bb.utils.contains('DISTRO_FEATURES','EasyMesh','true','false',d)}"
  if [ $DISTRO_EM_ENABLED = 'true' ]; then
     install -d ${D}/usr/ccsp/EasyMesh
     install -m 0644 ${WORKDIR}/Easymesh*.json  ${D}/usr/ccsp/EasyMesh/EasymeshCfg.json
  fi
}

FILES_${PN}_append = "${@bb.utils.contains('DISTRO_FEATURES', 'EasyMesh', ' /usr/ccsp/EasyMesh/* ', '', d)}"

FILES_${PN} += " \
  /usr/ccsp/wifi/* \
"
