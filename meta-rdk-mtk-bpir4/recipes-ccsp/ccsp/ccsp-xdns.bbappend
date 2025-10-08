include ccsp_common_bananapi.inc

TARGET_CFLAGS += "-Wno-error=address"
FILES:${PN}-dev += "${libdir}/*.so"
