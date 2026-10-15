FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI_append = " ${@bb.utils.contains('DISTRO_FEATURES', 'dynamic_keying', ' file://authkeys.patch', '', d)}"
