# USP-PA Feature
DISTRO_FEATURES_append = " usppa"

DISTRO_FEATURES_append = " WanManagerUnificationEnable"

DISTRO_FEATURES_append = " rdkb_wan_manager"

CFLAGS_append  = " ${@bb.utils.contains('DISTRO_FEATURES', 'rdkb_wan_manager', '-DFEATURE_RDKB_WAN_MANAGER', '', d)}"

DISTRO_FEATURES_append = " halVersion3"

#rdk-wifi-libhostap support for broadband
DISTRO_FEATURES_append = " HOSTAPD_2_11"

# OneWifi feature
DISTRO_FEATURES_append = " OneWifi onewifi_integration"

# MacFilter Feature
DISTRO_FEATURES_append = " disable_nl80211_acl"

#No Moca Support
DISTRO_FEATURES_append = " no_moca_support"

DISTRO_FEATURES_append = " referencepltfm "

MACHINEOVERRIDES_append =. "${@bb.utils.contains('DISTRO_FEATURES', 'OneWifi', ':onewifi', '' ,d)}"

DISTRO_FEATURES_append = " CPUPROCANALYZER_BROADBAND"

# RDKB-51565,RDKB-50795: [HAL] Cellular Hal Implementation
DISTRO_FEATURES_append = " rdkb_cellular_manager_mm"

DISTRO_FEATURES_append = " partner_default_ext"

#Enable SDcard image as default
DISTRO_FEATURES_append = " sdmmc"

DISTRO_FEATURE_append = " rdkb_voice_manager_dmltr104_v2"

DISTRO_FEATURE_append = " telco_voice_feature_enable_persist"

#PPP Feature
#DISTRO_FEATURES_append = "ppp-enabled"

#disabling lan0_as_wan to allow lan0 interface to come
DISTRO_FEATURES_remove = " lan0_as_wan"

#Need to enable below distro once required changes are merged 
#DISTRO_FEATURES_append = " EasyMesh"
#DISTRO_FEATURES_append = " with_alsap"
#DISTRO_FEATURES_append = " Em_Unittest"
PREFERRED_VERSION_go = "1.24.%"

#Enable wps support
DISTRO_FEATURES_append = " wps_support"

#Enable resource optimization
DISTRO_FEATURES_append = " resource_optimization"

#Enable kernel_6_6 support
DISTRO_FEATURES_append = " kernel6-6"

DISTRO_FEATURES_append = " CONFIG_IEEE80211BE"

DISTRO_FEATURES_append = " generic_mlo"

#Enable the below DISTRO to enable Hybrid Hal(rndis/modem) for cellular devices
#DISTRO_FEATURES_append_broadband = " cellular_hybrid_support"

#Enable remote debugger
DISTRO_FEATURES_append = " rrd"
