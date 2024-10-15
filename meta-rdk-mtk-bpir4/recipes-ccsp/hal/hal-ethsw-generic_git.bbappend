FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
CFLAGS_append += " -D_PLATFORM_BANANAPI_R4_ "
SRC_URI_append += "file://Add_interface_Changes.patch"
