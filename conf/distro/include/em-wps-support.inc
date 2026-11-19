# em-wps-support.inc
#
# Append-style distro include that ensures the 'em_wps_support' DISTRO_FEATURE
# is set for both the gateway (bananapi4-rdk-broadband) and the extender
# (bananapi4-rdk-broadband-ap-extender) builds, without modifying the upstream
# rdk-bpi.inc / rdk-bpi-ap-extender.inc files.
#
# Required from meta-cmf-bananapi/conf/layer.conf so it applies to every
# machine that consumes this layer.
#
# Toggling: comment out the line below (or remove this require from layer.conf)
# to globally disable EasyMesh WPS. Onboarding VAPs live in InterfaceMap_em.json.
# This feature enables the WPS hostap build flags
# (UWM_EXT_WPS_SUPPORT and WPS_NOTIFY_DISABLE) in rdk-wifi-libhostap and
# ccsp-one-wifi when both 'em_extender' and 'em_wps_support' are in DISTRO_FEATURES.
# On the gateway (no 'em_extender'), em_wps_support also defines
# UWM_CTRL_WPS_SUPPORT for OneWifi and libwebconfig so the controller-side
# dedicated onboarding VAP path is omitted from builds that do not enable
# EasyMesh WPS. rdk-wifi-hal and libhostap have no controller-only code, so
# they are built with UWM_EXT_WPS_SUPPORT only, and only on the extender.
# This is intentionally distinct from the existing 'wps_support'
# DISTRO_FEATURE, which controls broader WPS code paths.

DISTRO_FEATURES_append = " em_wps_support"
