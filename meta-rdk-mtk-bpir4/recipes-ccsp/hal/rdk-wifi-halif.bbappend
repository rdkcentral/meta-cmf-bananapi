FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
  
SRC_URI += "${@bb.utils.contains('DISTRO_FEATURES', 'kernel6-12', ' ', bb.utils.contains('DISTRO_FEATURES', 'OneWifi', ' ', ' file://sta-network-wifiagent.patch', d), d)}"
SRC_URI += "${@bb.utils.contains('DISTRO_FEATURES', 'kernel6-12', ' ', bb.utils.contains('DISTRO_FEATURES', 'OneWifi', ' ', ' file://0002-Add-EHT-support.patch', d), d)}"
SRC_URI:onewifi += "${@bb.utils.contains('DISTRO_FEATURES', 'kernel6-12', ' ', ' file://sta-network.patch', d)}"

do_configure:prepend:wrynose() {
    sed -i 's/#define DEFAULT_DEVICE_FIELD_LEN 64/#define DEFAULT_DEVICE_FIELD_LEN 128/' ${S}/include/wifi_hal_generic.h
}
