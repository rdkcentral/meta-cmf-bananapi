RDEPENDS:packagegroup-rdk-ccsp-broadband:remove = " rdk-wifi-hal"

RDEPENDS:packagegroup-rdk-ccsp-broadband:append = " \
           ${@bb.utils.contains('DISTRO_FEATURES', 'OneWifi', 'rdk-wifi-hal', '' ,d)} \
           ${@bb.utils.contains('DISTRO_FEATURES', 'CPUPROCANALYZER_BROADBAND', 'cpuprocanalyzer', ' ', d)} \
           "
GWPROVAPP = "${@bb.utils.contains('DISTRO_FEATURES','rdkb_wan_manager','ccsp-gwprovapp', '' ,d)}"

RDEPENDS:packagegroup-rdk-ccsp-broadband:append = "${@bb.utils.contains('DISTRO_FEATURES', 'rdkb_cellular_manager_mm', ' rdk-cellularmanager-mm', ' ', d)}"
