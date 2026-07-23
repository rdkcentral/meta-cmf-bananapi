SRC_URI_remove = "git://github.com/rdkcentral/rdk-wifi-hal.git;protocol=https;branch=main;name=rdk-wifi-hal"

SRC_URI += "git://github.com/rdkcentral/rdk-wifi-hal.git;protocol=https;branch=develop;name=rdk-wifi-hal"
SRCREV_rdk-wifi-hal = "049cb673580de3d752898cf1fe432514cab9fe73"

CFLAGS_append = " -D_PLATFORM_BANANAPI_R4_  -DBANANA_PI_PORT  -DFEATURE_SINGLE_PHY -DCONFIG_HW_CAPABILITIES "

CFLAGS_append = " ${@bb.utils.contains('DISTRO_FEATURES', 'generic_mlo', ' -DCONFIG_GENERIC_MLO -DCONFIG_MLO ', '', d)}"
CFLAGS_append = "${@bb.utils.contains_any('DISTRO_FEATURES', 'kernel6-12 kernel6-6' , ' -DKERNEL_6_6 ','', d)}"
CFLAGS_append = "${@bb.utils.contains('DISTRO_FEATURES', 'kernel6-12' , ' -DKERNEL_6_12 ','', d)}"
CFLAGS_append = " ${@bb.utils.contains('DISTRO_FEATURES', 'EasyMesh', ' -DEASY_MESH_NODE  ', '', d)}"
CFLAGS_append = "${@bb.utils.contains('DISTRO_FEATURES', 'em_extender', bb.utils.contains('DISTRO_FEATURES', 'em_wps_support', ' -DUWM_EXT_WPS_SUPPORT', '', d), '', d)}"

CFLAGS_append_kirkstone = " -fcommon"
CFLAGS_remove = "-DCONFIG_MBO"
EXTRA_OECONF_append = " ${@bb.utils.contains('DISTRO_FEATURES', 'OneWifi', ' ONE_WIFIBUILD=true ', '', d)}"
EXTRA_OECONF_append = " ${@bb.utils.contains('DISTRO_FEATURES', 'OneWifi', ' BANANA_PI_PORT=true ', '', d)}"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

# InterfaceMap variants (EasyMesh extender):
#   - InterfaceMap_em.json     : default EasyMesh extender map
#   - InterfaceMap_em_wps.json : WPS onboarding extender map
# InterfaceMap selection:
#   - EasyMesh + em_wps_support  -> InterfaceMap_em_wps.json
#   - EasyMesh (no em_wps_support) -> InterfaceMap_em.json
#   - No EasyMesh                -> InterfaceMap.json
#
# EasymeshCfg variants:
#   - EasymeshCfg.json         : EasyMesh controller (gw)
#   - EasymeshCfg_ext.json     : EasyMesh extender
#   - EasymeshCfg_ext_wps.json : EasyMesh extender WPS onboarding
SRC_URI += " \
  ${@bb.utils.contains('DISTRO_FEATURES', 'EasyMesh', \
        bb.utils.contains('DISTRO_FEATURES', 'em_wps_support', 'file://InterfaceMap_em_wps.json ', 'file://InterfaceMap_em.json ', d), \
        'file://InterfaceMap.json ', d)} \
  ${@bb.utils.contains('DISTRO_FEATURES', 'EasyMesh', \
        bb.utils.contains('DISTRO_FEATURES', 'em_extender', \
              bb.utils.contains('DISTRO_FEATURES', 'em_wps_support', 'file://EasymeshCfg_ext_wps.json ', 'file://EasymeshCfg_ext.json ', d), \
              'file://EasymeshCfg.json ', d), \
        ' ', d)} \
"

do_install_append() {
  install -d ${D}/usr/ccsp/wifi
  DISTRO_EM_ENABLED="${@bb.utils.contains('DISTRO_FEATURES','EasyMesh','true','false',d)}"
  DISTRO_EM_EXTENDER_ENABLED="${@bb.utils.contains('DISTRO_FEATURES','em_extender','true','false',d)}"
  DISTRO_EM_WPS_ENABLED="${@bb.utils.contains('DISTRO_FEATURES','em_wps_support','true','false',d)}"
  if [ $DISTRO_EM_ENABLED = 'true' ]; then
     if [ $DISTRO_EM_WPS_ENABLED = 'true' ]; then
        install -m 0644 ${WORKDIR}/InterfaceMap_em_wps.json ${D}/usr/ccsp/wifi/InterfaceMap.json
     else
        install -m 0644 ${WORKDIR}/InterfaceMap_em.json ${D}/usr/ccsp/wifi/InterfaceMap.json
     fi
     install -d ${D}/usr/ccsp/EasyMesh
     if [ $DISTRO_EM_EXTENDER_ENABLED = 'true' ]; then
        if [ $DISTRO_EM_WPS_ENABLED = 'true' ]; then
           install -m 0644 ${WORKDIR}/EasymeshCfg_ext_wps.json ${D}/usr/ccsp/EasyMesh/EasymeshCfg.json
        else
           install -m 0644 ${WORKDIR}/EasymeshCfg_ext.json ${D}/usr/ccsp/EasyMesh/EasymeshCfg.json
        fi
     else
        install -m 0644 ${WORKDIR}/EasymeshCfg.json ${D}/usr/ccsp/EasyMesh/EasymeshCfg.json
     fi
  else
     install -m 0644 ${WORKDIR}/InterfaceMap.json ${D}/usr/ccsp/wifi/InterfaceMap.json
  fi
}

FILES_${PN} += " \
  /usr/ccsp/wifi/* \
"

FILES_${PN}_append = "${@bb.utils.contains('DISTRO_FEATURES', 'EasyMesh', ' /usr/ccsp/EasyMesh/* ', '', d)}"
