FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI_remove = "git://git01.mediatek.com/filogic/rdk-b/rdkb_hal;protocol=https;branch=master;destsuffix=git/"
SRC_URI += "git://github.com/mediatek/rdkb_hal;protocol=https;branch=main;destsuffix=git/"
SRC_URI += "file://6g_dml_mapping.patch"

CFLAGS:append = " -D_PLATFORM_BANANAPI_R4_  -D_WIFI_AX_SUPPORT_ "
