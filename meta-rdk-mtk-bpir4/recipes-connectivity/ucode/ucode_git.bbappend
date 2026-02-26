DEPENDS:remove = "${@bb.utils.contains('DISTRO_FEATURES', 'OneWifi', 'ubus uci', '', d)}"
EXTRA_OECMAKE += "${@bb.utils.contains('DISTRO_FEATURES', 'OneWifi', '-DUBUS_SUPPORT=OFF -DUCI_SUPPORT=OFF', '', d)}"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI:remove:scarthgap = "\
    file://0001-change-cmakelist.patch \
"
SRC_URI:append:scarthgap = " file://0001-change-cmakelist-updated.patch"

