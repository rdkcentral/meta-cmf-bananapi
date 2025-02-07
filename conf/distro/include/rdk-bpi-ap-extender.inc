DISTRO_FEATURES_append = " halVersion3"

#rdk-wifi-libhostap support for broadband
DISTRO_FEATURES_append = " HOSTAPD_2_10"

# OneWifi feature
DISTRO_FEATURES_append = " OneWifi"
DISTRO_FEATURES_append = " rdk-wifi-hal"
DISTRO_FEATURES_append = " rdk-wifi-libhostap"
DISTRO_FEATURES_append = " hal-wifi-generic"

#DISTRO_FEATURES_append = " hal"
#DISTRO_FEATURES_append = " wifi"

DISTRO_FEATURES_append_broadband = " webconfig_bin"

# Only append 'rdk-wifi-hal' if OneWifi is enabled
#DEPENDS_append = "${@bb.utils.contains('DISTRO_FEATURES', 'OneWifi', ' rdk-wifi-hal', '', d)}"
#DEPENDS_append = "${@bb.utils.contains('DISTRO_FEATURES', 'OneWifi', ' hostapd', '', d)}"

# MacFilter Feature
DISTRO_FEATURES_append = " acl_nl_support"

#No Moca Support
DISTRO_FEATURES_append = " no_moca_support"

DISTRO_FEATURES_append = " referencepltfm "

MACHINEOVERRIDES_append = "${@bb.utils.contains('DISTRO_FEATURES', 'OneWifi', ':onewifi', '' ,d)}"

#Dac Feature support for BPIR4 device.
DISTRO_FEATURES_append = " dac"

DISTRO_FEATURES_append = " partner_default_ext"

# Define extender feature
DISTRO_FEATURES_append = " extender"

