
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI:remove:scarthgap = "\
    file://0001-change-cmakelist.patch \
"
SRC_URI:append:scarthgap = " file://0001-change-cmakelist-updated.patch"
