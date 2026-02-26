FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI:remove:scarthgap = "\
    file://0001-version-libraries.patch \
    file://fix-libdir.patch \
"
SRC_URI:append:scarthgap = "file://0001-version-libraries-fix-libdir-scarthgap-updated.patch"
