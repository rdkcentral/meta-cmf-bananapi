FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
  
SRC_URI:remove:onewifi = "git://github.com/rdkcentral/rdkb-halif-wifi.git;protocol=https;branch=main"
SRC_URI:onewifi = "git://github.com/rdkcentral/rdkb-halif-wifi.git;protocol=https;branch=develop"
SRCREV:onewifi = "c586c6d9f1321fa4fa6bfa8e9106226fd3600312"

SRC_URI += "${@bb.utils.contains('DISTRO_FEATURES', 'OneWifi', ' ', ' file://sta-network-wifiagent.patch', d)}"
SRC_URI += "${@bb.utils.contains('DISTRO_FEATURES', 'OneWifi', ' ', ' file://0002-Add-EHT-support.patch', d)}"
SRC_URI:onewifi += " file://sta-network.patch"
