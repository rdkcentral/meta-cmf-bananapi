FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
  
SRC_URI_remove_onewifi = "git://github.com/rdkcentral/rdkb-halif-wifi.git;protocol=https;branch=main"
SRC_URI_onewifi = "git://github.com/rdkcentral/rdkb-halif-wifi.git;protocol=https;branch=develop"
SRCREV_onewifi = "e48197014607dcaab1904ca54d56ae00a250c474"

SRC_URI += "${@bb.utils.contains('DISTRO_FEATURES', 'OneWifi', ' ', ' file://sta-network-wifiagent.patch', d)}"
SRC_URI += "${@bb.utils.contains('DISTRO_FEATURES', 'OneWifi', ' ', ' file://0002-Add-EHT-support.patch', d)}"
SRC_URI_onewifi += " file://sta-network.patch"
