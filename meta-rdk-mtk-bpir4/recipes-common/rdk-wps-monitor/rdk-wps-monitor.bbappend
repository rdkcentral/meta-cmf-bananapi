# Gateway: dedicated onboarding VAP window. Extender: station AccessPoint.16.
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://0001-WPS-button-extender-station-interface.patch"

CFLAGS_append = " ${@bb.utils.contains('DISTRO_FEATURES', 'em_extender', ' -DCONFIG_EXTENDER', '', d)}"
