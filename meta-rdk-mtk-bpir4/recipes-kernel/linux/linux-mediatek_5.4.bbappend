FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append += " \
    ${@bb.utils.contains('DISTRO_FEATURES','sdmmc','file://rdkb_cfg/sdmmc.cfg','',d)} \
"
