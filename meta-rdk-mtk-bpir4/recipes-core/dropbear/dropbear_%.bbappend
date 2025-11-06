FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI:remove:scarthgap = "\
    file://rdkb-dropbear-extend-default-path.patch \
"
SRC_URI:append:scarthgap = " file://rdkb-dropbear-extend-default-path-updated.patch"
