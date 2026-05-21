FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = " file://1000-get-station-increase-buffer-size.patch "
SRC_URI:append = " file://1001-BPIR4_Enable_Beacon_Frame_Subscription.patch "
SRC_URI:append = "${@bb.utils.contains('DISTRO_FEATURES', 'OneWifi', ' file://1002-MAC-ACL-support-for-BPI.patch', ' ', d)}"
