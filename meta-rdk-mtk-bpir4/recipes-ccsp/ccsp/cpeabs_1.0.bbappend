CFLAGS_append = " ${@bb.utils.contains('DISTRO_FEATURES', 'webconfig_bin', '-D_PLATFORM_BANANAPI_R4_', '', d)}"
