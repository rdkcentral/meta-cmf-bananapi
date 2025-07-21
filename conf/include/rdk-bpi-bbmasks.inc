BBMASK .= "|meta-cmf-filogic/recipes-extended/tdkb/"

BBMASK .= "${@bb.utils.contains('DISTRO_FEATURES', 'OneWifi', '|meta-filogic/recipes-wifi/hostapd/', '', d)}"
BBMASK .= "${@bb.utils.contains('DISTRO_FEATURES', 'OneWifi', '|meta-filogic/recipes-wifi/hal/halinterface.bbappend', '', d)}"
BBMASK .= "${@bb.utils.contains('DISTRO_FEATURES', 'OneWifi', '|meta-cmf-filogic/recipes-common/mesh-agent/mesh-agent.bbappend', '', d)}"

BBMASK_append_kirkstone .= "|meta-rdk-opensync/recipes/python3-jinja2/python3-jinja2_2.11.1.bb"
BBMASK .= "|meta-cmf/recipes-core/images/rdk-ipstb-oss-image.bb"
BBMASK .= "|meta-cmf/recipes-core/images/rdk-ipstb-oss-tdk-image.bb"
BBMASK .= "${@bb.utils.contains('DISTRO_FEATURES', 'OneWifi', '|meta-cmf-filogic/recipes-common/mesh-agent/mesh-agent.bbappend', '', d)}"
BBMASK .= "${@bb.utils.contains('DISTRO_FEATURES','EasyMesh','|openembedded-core/meta/recipes-devtools/rust/','',d)}"
BBMASK .= "|meta-rdk-ext/recipes-telephony/asterisk/asterisk_18.5.0.bb"
