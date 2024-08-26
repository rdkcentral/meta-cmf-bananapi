FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append = " file://Bpi_rdkwifilibhostap_changes.patch "

CFLAGS_append = " -D_PLATFORM_BANANAPI_R4_"
