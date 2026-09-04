# USP-PA Feature
DISTRO_FEATURES:append = " usppa"

DISTRO_FEATURES:append = " WanManagerUnificationEnable"

DISTRO_FEATURES:append = " rdkb_wan_manager"

DISTRO_FEATURES:append = " halVersion3"

DISTRO_FEATURES_append = " bridgeUtilsBin"

#rdk-wifi-libhostap support for broadband
DISTRO_FEATURES:append = " HOSTAPD_2_11"

# OneWifi feature
DISTRO_FEATURES:append = " OneWifi onewifi_integration"

#No Moca Support
DISTRO_FEATURES:append = " no_moca_support"

DISTRO_FEATURES:append = " referencepltfm "

MACHINEOVERRIDES:append =. "${@bb.utils.contains('DISTRO_FEATURES', 'OneWifi', ':onewifi', '' ,d)}"

MACHINEOVERRIDES:append = "${@bb.utils.contains('DISTRO_FEATURES', 'kernel6-6', ':kernel6-6', bb.utils.contains('DISTRO_FEATURES', 'kernel6-12', ':kernel6-12','',d), d)}"

DISTRO_FEATURES:append = " CPUPROCANALYZER_BROADBAND"

# RDKB-51565,RDKB-50795: [HAL] Cellular Hal Implementation
DISTRO_FEATURES:append = " rdkb_cellular_manager_mm"

DISTRO_FEATURES:append = " partner_default_ext"

#Enable SDcard image as default
DISTRO_FEATURES:append = " sdmmc"

DISTRO_FEATURE:append = " rdkb_voice_manager_dmltr104_v2"

DISTRO_FEATURE:append = " telco_voice_feature_enable_persist"

#PPP Feature
#DISTRO_FEATURES:append = "ppp-enabled"

#disabling lan0_as_wan to allow lan0 interface to come
DISTRO_FEATURES:remove = " lan0_as_wan"

#Need to enable below distro once required changes are merged 
#DISTRO_FEATURES:append = " EasyMesh"
#DISTRO_FEATURES:append = " with_alsap"
#DISTRO_FEATURES:append = " Em_Unittest"
PREFERRED_VERSION_go = "1.24.%"

#Enable below distro to build Easymesh and dependent Wi-Fi components from tip (AUTOREV) during CI validation
#DISTRO_FEATURES_append = " BuildFromTip"

#Enable wps support
DISTRO_FEATURES:append = " wps_support"

#Enable resource optimization
DISTRO_FEATURES:append = " resource_optimization"

#Enable kernel_6_6 support
#DISTRO_FEATURES:append = " kernel6-6"
DISTRO_FEATURES:append = " kernel6-12"
PREFERRED_VERSION_linux-libc-headers:wrynose = "6.12"

DISTRO_FEATURES:append = " CONFIG_IEEE80211BE"

DISTRO_FEATURES:append = " matter"
PREFERRED_VERSION_barton-matter = "1.4.2"

DISTRO_FEATURES:append = " generic_mlo"

#Enable the below DISTRO to enable Hybrid Hal(rndis/modem) for cellular devices
#DISTRO_FEATURES:append_broadband = " cellular_hybrid_support"

#Disable rdm-agent for reference platform
#DISTRO_FEATURES:append = "RDM"

DISTRO_FEATURES:append = " dhcp_manager "
DISTRO_FEATURES:append = " rdkb_configurable_wan_interface"
#Enable remote debugger
DISTRO_FEATURES:append = " rrd"

#Enable MAP-T
DISTRO_FEATURES:append = " feature_mapt"
DISTRO_FEATURES:append = " nat46"
LINUXLIBCVERSION = "${@bb.utils.contains('DISTRO_FEATURES', 'kernel6-12', '6.12%', bb.utils.contains('DISTRO_FEATURES','kernel6-6', '6.6%', '5.4%',d), d)}"
