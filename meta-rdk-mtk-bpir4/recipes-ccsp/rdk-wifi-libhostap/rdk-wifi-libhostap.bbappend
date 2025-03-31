FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

LIC_FILES_CHKSUM_remove = "file://source/hostap-2.10/README;md5=e3d2f6c2948991e37c1ca4960de84747"
LIC_FILES_CHKSUM = "file://source/hostap-2.11/README;md5=6e4b25e7d74bfc44a32ba37bdf5210a6"

SRC_URI_remove = " file://Rpi_rdkwifilibhostap_changes.patch"
SRC_URI_remove = " file://fixed_6G_wrong_freq.patch"
SRC_URI_append = " ${@bb.utils.contains('DISTRO_FEATURES', 'HOSTAPD_2_10', 'file://2.10/wpa3_compatibility_hostap_2_10.patch', '', d)}"
SRC_URI_append = " ${@bb.utils.contains('DISTRO_FEATURES', 'HOSTAPD_2_11', 'file://2.11/Bpi_rdkwifilibhostap_2_11_changes.patch', 'file://2.10/Bpi_rdkwifilibhostap_2_10_changes.patch', d)}"

CFLAGS_append = " -D_PLATFORM_BANANAPI_R4_"
