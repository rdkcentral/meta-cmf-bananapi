FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

CFLAGS_append = " -D_PLATFORM_BANANAPI_R4_  -DBANANA_PI_PORT  -DFEATURE_SINGLE_PHY -DCONFIG_HW_CAPABILITIES "
CFLAGS_append = "${@bb.utils.contains('DISTRO_FEATURES', 'em_extender', bb.utils.contains('DISTRO_FEATURES', 'em_wps_support', ' -DUWM_EXT_WPS_SUPPORT', '', d), '', d)}"

CFLAGS_append = "${@bb.utils.contains_any('DISTRO_FEATURES', 'kernel6-12 kernel6-6' , ' -DKERNEL_6_6 ','', d)}"
CFLAGS_append = "${@bb.utils.contains('DISTRO_FEATURES', 'kernel6-12' , ' -DKERNEL_6_12 -DHOSTAPD_211_V6 ','', d)}"
CFLAGS_append = " -fcommon"
EXTRA_OECONF_append = " ${@bb.utils.contains('DISTRO_FEATURES', 'OneWifi', ' ONE_WIFIBUILD=true ', '', d)}"
EXTRA_OECONF_append = " ${@bb.utils.contains('DISTRO_FEATURES', 'OneWifi', ' BANANA_PI_PORT=true ', '', d)}"


# InterfaceMap:
#   EasyMesh + em_wps_support + em_extender -> InterfaceMap_em_wps_ext.json
#   EasyMesh + em_wps_support                -> InterfaceMap_em_wps.json (dedicated onboarding VAPs)
#   EasyMesh                                 -> InterfaceMap_em.json
#   otherwise                                -> InterfaceMap.json
# EasymeshCfg is installed only for EasyMesh WPS so a non-WPS image is unchanged.
# The extender WPS cfg omits backhaul credentials so station onboarding can start.
SRC_URI += " \
  ${@bb.utils.contains('DISTRO_FEATURES', 'EasyMesh', \
        bb.utils.contains('DISTRO_FEATURES', 'em_wps_support', \
              bb.utils.contains('DISTRO_FEATURES', 'em_extender', 'file://InterfaceMap_em_wps_ext.json ', 'file://InterfaceMap_em_wps.json ', d), \
              'file://InterfaceMap_em.json ', d), \
        'file://InterfaceMap.json ', d)} \
  ${@bb.utils.contains('DISTRO_FEATURES', 'EasyMesh', \
        bb.utils.contains('DISTRO_FEATURES', 'em_wps_support', \
              bb.utils.contains('DISTRO_FEATURES', 'em_extender', 'file://EasymeshCfg_ext_wps.json ', 'file://EasymeshCfg.json ', d), \
              '', d), \
        '', d)} \
"

do_install_append() {
  install -d ${D}/usr/ccsp/wifi
  DISTRO_EM_ENABLED="${@bb.utils.contains('DISTRO_FEATURES','EasyMesh','true','false',d)}"
  DISTRO_EM_EXTENDER_ENABLED="${@bb.utils.contains('DISTRO_FEATURES','em_extender','true','false',d)}"
  DISTRO_EM_WPS_ENABLED="${@bb.utils.contains('DISTRO_FEATURES','em_wps_support','true','false',d)}"
  if [ $DISTRO_EM_ENABLED = 'true' ]; then
     if [ $DISTRO_EM_WPS_ENABLED = 'true' ]; then
        if [ $DISTRO_EM_EXTENDER_ENABLED = 'true' ]; then
           install -m 0644 ${WORKDIR}/InterfaceMap_em_wps_ext.json ${D}/usr/ccsp/wifi/InterfaceMap.json
           install -d ${D}/usr/ccsp/EasyMesh
           install -m 0644 ${WORKDIR}/EasymeshCfg_ext_wps.json ${D}/usr/ccsp/EasyMesh/EasymeshCfg.json
        else
           install -m 0644 ${WORKDIR}/InterfaceMap_em_wps.json ${D}/usr/ccsp/wifi/InterfaceMap.json
           install -d ${D}/usr/ccsp/EasyMesh
           install -m 0644 ${WORKDIR}/EasymeshCfg.json ${D}/usr/ccsp/EasyMesh/EasymeshCfg.json
        fi
     else
        install -m 0644 ${WORKDIR}/InterfaceMap_em.json ${D}/usr/ccsp/wifi/InterfaceMap.json
     fi
  else
     install -m 0644 ${WORKDIR}/InterfaceMap.json ${D}/usr/ccsp/wifi/InterfaceMap.json
  fi
}

FILES_${PN}_append = "${@bb.utils.contains('DISTRO_FEATURES', 'EasyMesh', ' /usr/ccsp/EasyMesh/* ', '', d)}"

FILES_${PN} += " \
  /usr/ccsp/wifi/* \
"
