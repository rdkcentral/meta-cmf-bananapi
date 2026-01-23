FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += "file://6g_dml_mapping.patch"

CFLAGS:append = " -D_PLATFORM_BANANAPI_R4_  -D_WIFI_AX_SUPPORT_ "
