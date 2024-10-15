RDEPENDS_packagegroup-rdk-ccsp-broadband_remove = " rdk-wifi-hal"
RDEPENDS_packagegroup-rdk-ccsp-broadband_append = "${@bb.utils.contains('DISTRO_FEATURES', 'OneWifi', 'rdk-wifi-hal', '' ,d)}"
GWPROVAPP = "${@bb.utils.contains('DISTRO_FEATURES','rdkb_wan_manager','ccsp-gwprovapp', '' ,d)}"
