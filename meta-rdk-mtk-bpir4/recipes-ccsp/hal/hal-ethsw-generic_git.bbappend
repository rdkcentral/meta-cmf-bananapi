FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
CFLAGS:append += " -D_PLATFORM_BANANAPI_R4_ "
SRC_URI:append += "file://Add_interface_Changes.patch"
