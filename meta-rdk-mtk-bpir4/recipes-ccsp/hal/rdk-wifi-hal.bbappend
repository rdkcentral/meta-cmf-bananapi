FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

CFLAGS:append = " -D_PLATFORM_BANANAPI_R4_  -DBANANA_PI_PORT  -DFEATURE_SINGLE_PHY -DCONFIG_HW_CAPABILITIES "

CFLAGS:append = "${@bb.utils.contains_any('DISTRO_FEATURES', 'kernel6-12 kernel6-6' , ' -DKERNEL_6_6 ','', d)}"
CFLAGS:append = "${@bb.utils.contains('DISTRO_FEATURES', 'kernel6-12' , ' -DKERNEL_6_12 -DHOSTAPD_211_V6 ','', d)}"

CFLAGS:append:kernel6-12 = " -DKERNEL_6_12 -DHOSTAPD_2_11"
CFLAGS:append = " -fcommon"
CFLAGS:append:wrynose = " -fcommon"
EXTRA_OECONF:append = " ${@bb.utils.contains('DISTRO_FEATURES', 'OneWifi', ' ONE_WIFIBUILD=true ', '', d)}"
EXTRA_OECONF:append = " ${@bb.utils.contains('DISTRO_FEATURES', 'OneWifi', ' BANANA_PI_PORT=true ', '', d)}"


SRC_URI += " \
  ${@bb.utils.contains('DISTRO_FEATURES', 'EasyMesh', ' file://InterfaceMap_em.json ', 'file://InterfaceMap.json ', d)} \
"
#SRC_URI:append:wrynose = " file://rdk_wifi_hal_Wrynose.patch;patchdir=../"
# Install InterfaceMap.json in /usr/ccsp/wifi
do_install:append() {
  install -d ${D}/usr/ccsp/wifi
  install -m 0644 ${UNPACKDIR}/InterfaceMa*.json ${D}/usr/ccsp/wifi/InterfaceMap.json
}

FILES:${PN} += " \
  /usr/ccsp/wifi/* \
"

