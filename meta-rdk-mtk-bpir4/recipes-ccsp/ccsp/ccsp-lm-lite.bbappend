include ccsp_common_bananapi.inc

EXTRA_OEMAKE += "LIBS='-lrbus'"

FILES:${PN}-dev += "${libdir}/*.so"
INSANE_SKIP:${PN} += "dev-so"
