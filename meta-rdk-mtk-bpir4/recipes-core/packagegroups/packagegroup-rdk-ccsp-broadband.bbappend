RDEPENDS_packagegroup-rdk-ccsp-broadband_remove = " rdk-wifi-hal"

RDEPENDS_packagegroup-rdk-ccsp-broadband_append = " rdk-speedtest-cli"
RDEPENDS_packagegroup-rdk-ccsp-broadband_append = " iperf3"
RDEPENDS_packagegroup-rdk-ccsp-broadband_append = " parodus2ccsp"

RDEPENDS_packagegroup-rdk-ccsp-broadband_append = " \
           ${@bb.utils.contains('DISTRO_FEATURES', 'OneWifi', 'rdk-wifi-hal', '' ,d)} \
           ${@bb.utils.contains('DISTRO_FEATURES', 'CPUPROCANALYZER_BROADBAND', 'cpuprocanalyzer', ' ', d)} \
           "
GWPROVAPP = "${@bb.utils.contains('DISTRO_FEATURES','rdkb_wan_manager','ccsp-gwprovapp', '' ,d)}"

RDEPENDS_packagegroup-rdk-ccsp-broadband_append = "${@bb.utils.contains('DISTRO_FEATURES', 'rdkb_cellular_manager_mm', ' rdk-cellularmanager-mm', ' ', d)}"
RDEPENDS_packagegroup-rdk-ccsp-broadband_append = " gw-lan-refresh"
