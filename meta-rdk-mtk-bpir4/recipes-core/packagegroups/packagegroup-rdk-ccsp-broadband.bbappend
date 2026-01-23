RDEPENDS:packagegroup-rdk-ccsp-broadband:remove = " rdk-wifi-hal"

RDEPENDS:packagegroup-rdk-ccsp-broadband:append = " rdk-speedtest-cli"
RDEPENDS:packagegroup-rdk-ccsp-broadband:append = " iperf3"
RDEPENDS:packagegroup-rdk-ccsp-broadband:append = " parodus2ccsp"

RDEPENDS:packagegroup-rdk-ccsp-broadband:append = " \
           ${@bb.utils.contains('DISTRO_FEATURES', 'OneWifi', 'rdk-wifi-hal', '' ,d)} \
           ${@bb.utils.contains('DISTRO_FEATURES', 'CPUPROCANALYZER_BROADBAND', 'cpuprocanalyzer', ' ', d)} \
           ${@bb.utils.contains('DISTRO_FEATURES', 'cellular_hybrid_support', 'usbmuxd', ' ', d)} \
           ${@bb.utils.contains('DISTRO_FEATURES', 'cellular_hybrid_support', 'usb-modeswitch', ' ', d)} \
           ${@bb.utils.contains('DISTRO_FEATURES', 'cellular_hybrid_support', 'usb-modeswitch-data', ' ', d)} \
           ${@bb.utils.contains('DISTRO_FEATURES', 'cellular_hybrid_support', 'modemmanager', ' ', d)} \
           "
GWPROVAPP = "${@bb.utils.contains('DISTRO_FEATURES','rdkb_wan_manager','ccsp-gwprovapp', '' ,d)}"

RDEPENDS:packagegroup-rdk-ccsp-broadband:append = "${@bb.utils.contains('DISTRO_FEATURES', 'rdkb_cellular_manager_mm', ' rdk-cellularmanager-mm', ' ', d)}"
RDEPENDS:packagegroup-rdk-ccsp-broadband:append = " rdktelcovoicemanager"
RDEPENDS:packagegroup-rdk-ccsp-broadband:append = " gw-lan-refresh"
