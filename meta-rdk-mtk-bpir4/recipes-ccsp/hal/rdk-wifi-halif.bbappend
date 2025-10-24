FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
  
SRC_URI_remove_onewifi = "git://github.com/rdkcentral/rdkb-halif-wifi.git;protocol=https;branch=main"
SRC_URI_onewifi = "git://github.com/rdkcentral/rdkb-halif-wifi.git;protocol=https;branch=develop"
SRCREV_onewifi = "5e98c960363bd79027775101cbd9d11c5e9d6c26"

SRC_URI += "${@bb.utils.contains('DISTRO_FEATURES', 'OneWifi', ' ', ' file://sta-network-wifiagent.patch', d)}"
SRC_URI += "${@bb.utils.contains('DISTRO_FEATURES', 'OneWifi', ' ', ' file://0002-Add-EHT-support.patch', d)}"
SRC_URI_onewifi += " file://sta-network.patch"
