include ccsp_common_bananapi.inc

#FILES:${PN}-dev += "${libdir}/*.so"
INSANE_SKIP:${PN} += "dev-so"

SRC_URI:remove = "file://filogic-factoryReset.patch"

