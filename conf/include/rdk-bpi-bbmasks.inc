BBMASK .= "|meta-cmf-filogic/recipes-extended/tdkb/"

BBMASK .= "${@bb.utils.contains('DISTRO_FEATURES', 'OneWifi', '|meta-filogic/recipes-wifi/hostapd/', '', d)}"
BBMASK .= "${@bb.utils.contains('DISTRO_FEATURES', 'OneWifi', '|meta-cmf-filogic/recipes-common/mesh-agent/mesh-agent.bbappend', '', d)}"

BBMASK_append_kirkstone .= "|meta-rdk-opensync/recipes/python3-jinja2/python3-jinja2_2.11.1.bb"
BBMASK .= "|meta-cmf/recipes-core/images/rdk-ipstb-oss-image.bb"
BBMASK .= "|meta-cmf/recipes-core/images/rdk-ipstb-oss-tdk-image.bb"
BBMASK .= "${@bb.utils.contains('DISTRO_FEATURES', 'OneWifi', '|meta-cmf-filogic/recipes-common/mesh-agent/mesh-agent.bbappend', '', d)}"
BBMASK .= "${@bb.utils.contains('DISTRO_FEATURES','EasyMesh','|openembedded-core/meta/recipes-devtools/rust/','',d)}"
BBMASK .= "${@bb.utils.contains('DISTRO_FEATURES','EasyMesh','|meta-cmf-filogic/recipes-ccsp/ccsp/ccsp-one-wifi.bbappend','',d)}"
BBMASK .= "|meta-cmf-filogic/recipes-ccsp/util/utopia-headers.bb"
BBMASK .= "|meta-cmf-filogic/recipes-ccsp/hal/halinterface.bbappend"
BBMASK .= "|meta-filogic/recipes-wifi/hal/halinterface.bbappend"
BBMASK .= "|meta-rdk-ext/recipes-telephony/asterisk/asterisk_18.5.0.bb"
BBMASK .= "|meta-rdk-broadband-apps/recipes-kernel/linux/linux-%.bbappend"
BBMASK .= "|meta-rdk-broadband/recipes-ccsp/ccsp/ccsp-adv-security.bb"
BBMASK .= "|meta-rdk-broadband/recipes-ccsp/ccsp/ccsp-home-security.bb"
BBMASK .= "|meta-rdk-broadband/recipes-ccsp/ccsp/ccsp-hotspot.bb"
BBMASK .= "|meta-rdk-broadband/recipes-ccsp/ccsp/ccsp-hotspot-kmod.bb"
BBMASK .= "|meta-rdk-broadband/recipes-ccsp/ccsp/ccsp-xdns.bb"

BBMASK .= "|meta-rdk-broadband/recipes-ccsp/hal/rdkb-halif-cm.bb"
BBMASK .= "|meta-rdk-broadband/recipes-ccsp/hal/rdkb-halif-moca.bb"
BBMASK .= "|meta-rdk-broadband/recipes-ccsp/hal/rdkb-halif-mta.bb"
BBMASK .= "|meta-rdk-broadband/recipes-ccsp/hal/hal-cm-generic_git.bb"
BBMASK .= "|meta-rdk-broadband/recipes-ccsp/hal/hal-moca-generic_git.bb"
BBMASK .= "|meta-rdk-broadband/recipes-ccsp/hal/hal-mta-generic_git.bb"

# DOCSIS-only agents - entire components not needed
BBMASK .= "|meta-rdk-broadband/recipes-ccsp/ccsp/ccsp-cm-agent.bb"
BBMASK .= "|meta-rdk-broadband/recipes-ccsp/ccsp/ccsp-mta-agent.bb"
BBMASK .= "|meta-rdk-broadband/recipes-ccsp/ccsp/ccsp-moca.bb"

#ccsp-xconf needs code refactoring
BBMASK .= "|meta-rdk-broadband/recipes-ccsp/ccsp/ccsp-xconf.bb"
