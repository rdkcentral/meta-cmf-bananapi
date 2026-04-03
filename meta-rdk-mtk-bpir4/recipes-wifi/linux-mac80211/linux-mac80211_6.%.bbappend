FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = " file://1000-get-station-increase-buffer-size.patch "
SRC_URI:append = " file://1001-BPIR4_Enable_Beacon_Frame_Subscription.patch "
SRC_URI:append:onewifi = "${@bb.utils.contains('DISTRO_FEATURES', 'kernel6-12', ' file://1002-MAC-ACL-support-for-BPI_v6.patch', ' file://1002-MAC-ACL-support-for-BPI.patch', d)}"
