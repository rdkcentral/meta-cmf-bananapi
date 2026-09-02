FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
  
SRC_URI:remove:onewifi = "git://github.com/rdkcentral/rdkb-halif-wifi.git;protocol=https;branch=main"
SRC_URI:onewifi = "git://github.com/rdkcentral/rdkb-halif-wifi.git;protocol=https;branch=develop"
SRCREV:onewifi = "${@bb.utils.contains('DISTRO_FEATURES', 'BuildFromTip', '${AUTOREV}', '6ef80d70f934695e7204d3728739cd59ca6f66a9', d)}"

SRC_URI += "${@bb.utils.contains('DISTRO_FEATURES', 'kernel6-12', ' ', bb.utils.contains('DISTRO_FEATURES', 'OneWifi', ' ', ' file://sta-network-wifiagent.patch', d), d)}"
SRC_URI += "${@bb.utils.contains('DISTRO_FEATURES', 'kernel6-12', ' ', bb.utils.contains('DISTRO_FEATURES', 'OneWifi', ' ', ' file://0002-Add-EHT-support.patch', d), d)}"
SRC_URI:onewifi += "${@bb.utils.contains('DISTRO_FEATURES', 'kernel6-12', ' ', ' file://sta-network.patch', d)}"
