FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:remove = "git://git01.mediatek.com/filogic/rdk-b/rdkb_hal;branch=master;protocol=https;destsuffix=git/source/platform/rdkb_hal"
SRC_URI += "git://github.com/mediatek/rdkb_hal;branch=main;protocol=https;name=rdkb_hal;destsuffix=git/source/platform/rdkb_hal"
SRCREV_rdkb_hal = "31f5afb748ea66ec4f08f6f5b325a22f73223f02"

SRC_URI:append = " file://Add_ipv6_changes.patch"
SRC_URI:append = " file://bpi_serial_no_fix.patch"
SRC_URI:append = " file://hal-function-changes.patch"
SRC_URI:append = " file://RDKBACCL-954-hal-change.patch"
SRC_URI:append = " file://configurable-wan-platform.patch"

do_configure:append() {
     #For trimming the spaces
     sed -i "s/cat \/proc\/device-tree\/model/cat \/proc\/device-tree\/model | tr -d ' '/g" ${S}/rdkb_hal/src/platform/platform_hal.c
}
