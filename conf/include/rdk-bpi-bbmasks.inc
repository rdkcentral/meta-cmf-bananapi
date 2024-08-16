BBMASK .= "|meta-cmf-filogic/recipes-extended/tdkb/"

BBMASK .= "${@bb.utils.contains('DISTRO_FEATURES', 'OneWifi', '|meta-filogic/recipes-wifi/hostapd/', '', d)}"
BBMASK .= "${@bb.utils.contains('DISTRO_FEATURES', 'OneWifi', '|meta-filogic/recipes-wifi/hal/halinterface.bbappend', '', d)}"
BBMASK .= "${@bb.utils.contains('DISTRO_FEATURES', 'OneWifi', '|meta-cmf-filogic/recipes-common/mesh-agent/mesh-agent.bbappend', '', d)}"
