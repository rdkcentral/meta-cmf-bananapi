SRC_URI_remove = "git://github.com/rdkcentral/rdk-wifi-hal.git;protocol=https;branch=main;name=rdk-wifi-hal"

SRC_URI += "git://github.com/rdkcentral/rdk-wifi-hal.git;protocol=https;branch=develop;name=rdk-wifi-hal"
SRCREV_rdk-wifi-hal = "a8bdea1dce2761060f54e4dfe8e69af19f3d9b1f"

CFLAGS_append = " -D_PLATFORM_BANANAPI_R4_  -DBANANA_PI_PORT  -DFEATURE_SINGLE_PHY "
CFLAGS_append_kirkstone = " -fcommon"
CFLAGS_remove = "-DCONFIG_MBO"
EXTRA_OECONF_append = " ${@bb.utils.contains('DISTRO_FEATURES', 'OneWifi', ' ONE_WIFIBUILD=true ', '', d)}"
EXTRA_OECONF_append = " ${@bb.utils.contains('DISTRO_FEATURES', 'OneWifi', ' BANANA_PI_PORT=true ', '', d)}"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += " \
  file://InterfaceMap.json \
  file://EasymeshCfg.json \
"

# Install InterfaceMap.json in /nvram
do_install_append() {
  install -d ${D}/nvram
  install -m 0644 ${WORKDIR}/InterfaceMap.json ${D}/nvram/InterfaceMap.json
  install -m 0644 ${WORKDIR}/EasymeshCfg.json  ${D}/nvram 
}

FILES_${PN} += " \
  /nvram/* \
"
