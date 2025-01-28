FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append = " file://Bpi_rdkwifilibhostap_changes.patch "
SRC_URI_append = " file://mbssid_support.patch "
SRC_URI_append = " file://Incorrect_6G_channel_to_frequency_conversion.patch "

CFLAGS_append = " -D_PLATFORM_BANANAPI_R4_"
