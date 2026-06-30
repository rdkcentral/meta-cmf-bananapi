FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = " file://Add_ipv6_changes.patch"
SRC_URI:append = " file://bpi_serial_no_fix.patch"
SRC_URI:append = " file://hal-function-changes.patch"
SRC_URI:append = " file://RDKBACCL-954-hal-change.patch"

do_configure:append() {
     #For trimming the spaces
     sed -i "s/cat \/proc\/device-tree\/model/cat \/proc\/device-tree\/model | tr -d ' '/g" ${S}/rdkb_hal/src/platform/platform_hal.c
}
