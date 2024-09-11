SUMMARY = "common inc for Banana Pi"

CFLAGS_remove = " -D_PLATFORM_TURRIS_ "
CFLAGS_append += " -D_COSA_INTEL_USG_ARM_ -D_COSA_FOR_COMCAST_ -D_COSA_BCM_ARM_ -DCONFIG_VENDOR_CUSTOMER_COMCAST "
CFLAGS_append += " -D_PLATFORM_BANANAPI_R4_ "
CFLAGS_append += " -DWAN_FAILOVER_SUPPORTED"
CFLAGS_append += " -DRBUS_BUILD_FLAG_ENABLE"
CFLAGS_append += " -DWAN_MANAGER_UNIFICATION_ENABLED"
CFLAGS_append += " -DFEATURE_SUPPORT_RDKLOG"
CFLAGS_append += " -DRBUS_BUILD_INTEGRATED"

CFLAGS_append  += " ${@bb.utils.contains('DISTRO_FEATURES', 'WanFailOverSupportEnable', ' -DWAN_FAILOVER_SUPPORTED -DRBUS_BUILD_FLAG_ENABLE', '', d)}"
CFLAGS_append  += " ${@bb.utils.contains('DISTRO_FEATURES', 'WanManagerUnificationEnable', '-DWAN_MANAGER_UNIFICATION_ENABLED', '', d)}"
CFLAGS_append += "${@bb.utils.contains('DISTRO_FEATURES', 'rdkb_wan_manager', ' -DFEATURE_RDKB_WAN_MANAGER ', '', d)}"


