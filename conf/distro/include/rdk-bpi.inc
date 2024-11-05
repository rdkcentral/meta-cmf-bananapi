# USP-PA Feature
DISTRO_FEATURES_append = " usppa"

DISTRO_FEATURES_append = " WanManagerUnificationEnable"

DISTRO_FEATURES_append = " rdkb_wan_manager"

CFLAGS_append  = " ${@bb.utils.contains('DISTRO_FEATURES', 'rdkb_wan_manager', '-DFEATURE_RDKB_WAN_MANAGER', '', d)}"

DISTRO_FEATURES_append = " halVersion3"

#rdk-wifi-libhostap support for broadband
DISTRO_FEATURES_append = " HOSTAPD_2_10"

# OneWifi feature
#DISTRO_FEATURES_append = " OneWifi"

# MacFilter Feature
DISTRO_FEATURES_append = " acl_nl_support"

#No Moca Support
DISTRO_FEATURES_append = " no_moca_support"

DISTRO_FEATURES_append = " referencepltfm "

MACHINEOVERRIDES_append =. "${@bb.utils.contains('DISTRO_FEATURES', 'OneWifi', ':onewifi', '' ,d)}"

DISTRO_FEATURES_append = " CPUPROCANALYZER_BROADBAND"

# RDKB-51565,RDKB-50795: [HAL] Cellular Hal Implementation
DISTRO_FEATURES_append = " rdkb_cellular_manager_mm"

#Dac Feature support for BPIR4 device.
DISTRO_FEATURES_append = " dac"
