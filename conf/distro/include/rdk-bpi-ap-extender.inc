DISTRO_FEATURES_append = " halVersion3"

#rdk-wifi-libhostap support for broadband
DISTRO_FEATURES_append = " HOSTAPD_2_11"

# OneWifi feature
DISTRO_FEATURES_append = " OneWifi onewifi_integration"

# MacFilter Feature
DISTRO_FEATURES_append = " acl_nl_support"

#No Moca Support
DISTRO_FEATURES_append = " no_moca_support"
DISTRO_FEATURES_append = " referencepltfm "

MACHINEOVERRIDES_append = "${@bb.utils.contains('DISTRO_FEATURES', 'OneWifi', ':onewifi', '' ,d)}"

DISTRO_FEATURES_append = " partner_default_ext"

# Define extender feature
DISTRO_FEATURES_append = " em_extender"
DISTRO_FEATURES_append = " sdmmc"

# Easymesh
DISTRO_FEATURES_append = " EasyMesh"
DISTRO_FEATURES_append = " sta_manager"
DISTRO_FEATURES_append = " with_alsap" 

# MLO
DISTRO_FEATURES_append = " CONFIG_IEEE80211BE"
DISTRO_FEATURES_append = " generic_mlo"
#PPP Feature
#DISTRO_FEATURES_append = "ppp-enabled"

# Kernel 6.6
DISTRO_FEATURES_append = " kernel6-6"

#Disable rdm-agent for reference platform
#DISTRO_FEATURES_append = "RDM"
