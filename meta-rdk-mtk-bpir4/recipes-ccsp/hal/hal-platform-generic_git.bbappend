FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append += "file://Add_ipv6_changes.patch"
do_configure_append() {
     #For trimming the spaces
     sed -i "s/cat \/proc\/device-tree\/model/cat \/proc\/device-tree\/model | tr -d ' '/g" ${S}/rdkb_hal/src/platform/platform_hal.c
}
