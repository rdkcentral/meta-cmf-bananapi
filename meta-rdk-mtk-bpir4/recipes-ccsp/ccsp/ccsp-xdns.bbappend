include ccsp_common_bananapi.inc

TARGET_CFLAGS += "-Wno-error=address"
INSANE_SKIP:${PN} += "dev-so"
