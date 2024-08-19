SUMMARY = "common inc for Banana Pi"

CFLAGS_remove = " -D_PLATFORM_TURRIS_ "

CFLAGS_append += " -D_COSA_INTEL_USG_ARM_ -D_COSA_FOR_COMCAST_ -D_COSA_BCM_ARM_ -DCONFIG_VENDOR_CUSTOMER_COMCAST "

CFLAGS_append += " -D_PLATFORM_BANANAPI_R4_ "

CFLAGS_append += "${@bb.utils.contains('DISTRO_FEATURES', 'rdkb_wan_manager', ' -DFEATURE_RDKB_WAN_MANAGER ', '', d)}"

