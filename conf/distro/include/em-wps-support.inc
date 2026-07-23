# em-wps-support.inc
#
# Optional EasyMesh extender WPS onboarding support. Included from
# rdk-bpi-ap-extender.inc (not layer.conf) so gateway builds are unaffected.
#
# Adds em_wps_support to DISTRO_FEATURES for extender images. Recipes such as
# rdk-wifi-hal.bbappend install InterfaceMap_em_wps.json and EasymeshCfg_ext_wps.json
# when EasyMesh and em_wps_support are enabled. rdk-wifi-libhostap and ccsp-one-wifi
# use em_wps_support (with em_extender where noted) for UWM_EXT_WPS_SUPPORT and
# WPS_NOTIFY_DISABLE. Distinct from the wps_support DISTRO_FEATURE.
#
# To disable WPS onboarding on an extender image, remove em_wps_support from
# DISTRO_FEATURES in the machine/distro configuration instead of editing recipes.

DISTRO_FEATURES_append = " em_wps_support"
