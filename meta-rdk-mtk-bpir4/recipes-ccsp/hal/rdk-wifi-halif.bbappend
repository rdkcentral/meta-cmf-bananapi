FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_remove_onewifi = "git://github.com/rdkcentral/rdkb-halif-wifi.git;protocol=https;branch=main"
SRC_URI_onewifi = "git://github.com/bsomanath/rdkb-halif-wifi.git;protocol=https;branch=RDKBWIFI-388-wps"
SRCREV_onewifi = "ca1bb7e441c2f286f24a93d9c361874a86fbf82d"
  
SRC_URI += "${@bb.utils.contains('DISTRO_FEATURES', 'kernel6-12', ' ', bb.utils.contains('DISTRO_FEATURES', 'OneWifi', ' ', ' file://sta-network-wifiagent.patch', d), d)}"
SRC_URI += "${@bb.utils.contains('DISTRO_FEATURES', 'kernel6-12', ' ', bb.utils.contains('DISTRO_FEATURES', 'OneWifi', ' ', ' file://0002-Add-EHT-support.patch', d), d)}"
SRC_URI_onewifi += "${@bb.utils.contains('DISTRO_FEATURES', 'kernel6-12', ' ', ' file://sta-network.patch', d)}"
