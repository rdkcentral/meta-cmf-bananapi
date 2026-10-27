# Controller-side EasyMesh WPS. Never defined on em_extender builds.
# The dedicated onboarding VAP path in OneWifi is compiled only when this
# macro is set, which em-wps-support.inc enables on the gateway.
SRC_URI_remove = "${CMF_GIT_ROOT}/rdkb/components/opensource/ccsp/OneWifi;protocol=${CMF_GIT_PROTOCOL};branch=${CMF_GIT_BRANCH};name=libwebconfig"
SRC_URI += "git://github.com/bsomanath/OneWifi.git;protocol=https;branch=RDKBWIFI-388-wps;name=libwebconfig"
SRCREV_libwebconfig = "bba271bcaaba68cc471303382b544f070b271fb9"

CFLAGS_append = " ${@bb.utils.contains('DISTRO_FEATURES', 'em_extender', '', bb.utils.contains('DISTRO_FEATURES', 'em_wps_support', ' -DUWM_CTRL_WPS_SUPPORT ', '', d), d)}"
