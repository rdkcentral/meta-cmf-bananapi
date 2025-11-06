FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI:remove:scarthgap = "\
    file://fix-rdkb-wan-get-status-fail.patch \
"
SRC_URI:append:scarthgap = " file://fix-rdkb-wan-get-status-fail-updated.patch"
