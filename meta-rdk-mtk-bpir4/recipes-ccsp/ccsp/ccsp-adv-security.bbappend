include ccsp_common_bananapi.inc

EXTRA_OEMAKE += "'SSP_LDFLAGS=${SSP_LDFLAGS}'"
SSP_LDFLAGS = " -lhal_platform"
