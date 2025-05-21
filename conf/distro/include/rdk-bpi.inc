# USP-PA Feature
DISTRO_FEATURES_append = " usppa"

DISTRO_FEATURES_append = " WanManagerUnificationEnable"

DISTRO_FEATURES_append = " rdkb_wan_manager"

CFLAGS_append  = " ${@bb.utils.contains('DISTRO_FEATURES', 'rdkb_wan_manager', '-DFEATURE_RDKB_WAN_MANAGER', '', d)}"

DISTRO_FEATURES_append = " halVersion3"

#rdk-wifi-libhostap support for broadband
DISTRO_FEATURES_append = " HOSTAPD_2_11"

# OneWifi feature
DISTRO_FEATURES_append = " OneWifi"

# MacFilter Feature
DISTRO_FEATURES_append = " disable_nl80211_acl"

#No Moca Support
DISTRO_FEATURES_append = " no_moca_support"

DISTRO_FEATURES_append = " referencepltfm "

MACHINEOVERRIDES_append =. "${@bb.utils.contains('DISTRO_FEATURES', 'OneWifi', ':onewifi', '' ,d)}"

DISTRO_FEATURES_append = " CPUPROCANALYZER_BROADBAND"

# RDKB-51565,RDKB-50795: [HAL] Cellular Hal Implementation
DISTRO_FEATURES_append = " rdkb_cellular_manager_mm"

#Dac Feature support for BPIR4 device.
DISTRO_FEATURES_append = " dac"

DISTRO_FEATURES_append = " partner_default_ext"

#Enable SDcard image as default
DISTRO_FEATURES_append = " sdmmc"

#PPP Feature
#DISTRO_FEATURES_append = "ppp-enabled"

#disabling lan0_as_wan to allow lan0 interface to come
DISTRO_FEATURES_remove = " lan0_as_wan"

#Need to enable below distro once required changes are merged 
#DISTRO_FEATURES_append = " EasyMesh"
#DISTRO_FEATURES_append = " sta_manager"
PREFERRED_VERSION_go = "1.19.%"
