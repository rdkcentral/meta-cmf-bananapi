# USP-PA Feature
DISTRO_FEATURES_append = " usppa"

DISTRO_FEATURES_append = " WanManagerUnificationEnable"

DISTRO_FEATURES_append = " rdkb_wan_manager"

CFLAGS_append  = " ${@bb.utils.contains('DISTRO_FEATURES', 'rdkb_wan_manager', '-DFEATURE_RDKB_WAN_MANAGER', '', d)}"

