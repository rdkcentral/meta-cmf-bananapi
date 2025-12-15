DEPENDS_remove = "${@bb.utils.contains('DISTRO_FEATURES', 'OneWifi', 'ubus uci', '', d)}"
EXTRA_OECMAKE += "${@bb.utils.contains('DISTRO_FEATURES', 'OneWifi', '-DUBUS_SUPPORT=OFF -DUCI_SUPPORT=OFF', '', d)}"
