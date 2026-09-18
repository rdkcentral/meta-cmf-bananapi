FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_remove= "git://git01.mediatek.com/filogic/rdk-b/rdkb_hal;protocol=https;branch=master;destsuffix=git/source/ethsw/rdkb_hal"
SRC_URI += "git://github.com/mediatek/rdkb_hal;protocol=https;branch=main;destsuffix=git/source/ethsw/rdkb_hal"

CFLAGS_append += " -D_PLATFORM_BANANAPI_R4_ "
SRC_URI_append += "file://Add_interface_Changes.patch"
SRC_URI_append += "file://gw_lan_refresh.patch"
SRC_URI_append += "file://Ethernet-Lan-changes.patch"
SRC_URI_append += "file://configurable-wan-interface-ethsw.patch"
SRC_URI_append += "file://vlan-manager-integration.patch"