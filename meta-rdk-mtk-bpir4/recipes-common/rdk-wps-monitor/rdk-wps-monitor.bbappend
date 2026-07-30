# Extender builds: WPS button drives station AccessPoint.16 (see broadband-utils RDKBWIFI-388)
CFLAGS_append = " ${@bb.utils.contains('DISTRO_FEATURES', 'em_extender', ' -DCONFIG_EXTENDER', '', d)}"
