DISTRO_FEATURES:append = " halVersion3"

#rdk-wifi-libhostap support for broadband
DISTRO_FEATURES:append = " HOSTAPD_2_11"

# OneWifi feature
DISTRO_FEATURES:append = " OneWifi onewifi_integration"

# MacFilter Feature
DISTRO_FEATURES:append = " acl_nl_support"

#No Moca Support
DISTRO_FEATURES:append = " no_moca_support"
DISTRO_FEATURES:append = " referencepltfm "

MACHINEOVERRIDES:append = "${@bb.utils.contains('DISTRO_FEATURES', 'OneWifi', ':onewifi', '' ,d)}"

MACHINEOVERRIDES:append = "${@bb.utils.contains('DISTRO_FEATURES', 'kernel6-6', ':kernel6-6', bb.utils.contains('DISTRO_FEATURES', 'kernel6-12', ':kernel6-12','',d), d)}"

DISTRO_FEATURES:append = " partner_default_ext"

# Define extender feature
DISTRO_FEATURES:append = " em_extender"
DISTRO_FEATURES:append = " sdmmc"

# Easymesh
DISTRO_FEATURES:append = " EasyMesh"
DISTRO_FEATURES:append = " with_alsap" 

# MLO
DISTRO_FEATURES:append = " CONFIG_IEEE80211BE"
DISTRO_FEATURES:append = " generic_mlo"
#PPP Feature
#DISTRO_FEATURES:append = "ppp-enabled"

# Kernel 6.6
DISTRO_FEATURES:append = " kernel6-6"
#DISTRO_FEATURES:append = " kernel6-12"

#Disable rdm-agent for reference platform
#DISTRO_FEATURES:append = "RDM"

#Enable below distro to build Easymesh and dependent Wi-Fi components from tip (AUTOREV) during CI validation
#DISTRO_FEATURES:append = " BuildFromTip"
