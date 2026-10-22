# Controller-side EasyMesh WPS. Never defined on em_extender builds.
# The dedicated onboarding VAP path in OneWifi is compiled only when this
# macro is set, which em-wps-support.inc enables on the gateway.
CFLAGS_append = " ${@bb.utils.contains('DISTRO_FEATURES', 'em_extender', '', bb.utils.contains('DISTRO_FEATURES', 'em_wps_support', ' -DUWM_CTRL_WPS_SUPPORT ', '', d), d)}"
