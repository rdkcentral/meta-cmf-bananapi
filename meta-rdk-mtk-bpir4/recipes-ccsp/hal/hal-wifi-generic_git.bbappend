SRC_URI_append = " \
    ${CMF_GIT_ROOT}/rdkb/devices/raspberrypi/hal;protocol=${CMF_GIT_PROTOCOL};branch=${CMF_GIT_BRANCH};destsuffix=git/source/wifi/devices_bpi;name=wifihal-bananapi \
"

SRCREV_wifihal-bananapi = "${AUTOREV}"

DEPENDS_append =" libev wpa-supplicant"
DEPENDS_append = "${@bb.utils.contains('DISTRO_FEATURES', 'OneWifi', ' rdk-wifi-hal', '', d)}"
LDFLAGS_append = " -lev -lwpa_client -lpthread"

do_configure_prepend(){
    rm ${S}/wifi_hal.c
    rm ${S}/Makefile.am
}

CFLAGS_append = " -DWIFI_HAL_VERSION_3 "
CFLAGS_append = " ${@bb.utils.contains('DISTRO_FEATURES', 'OneWifi', ' -D_ONE_WIFI_ ', '', d)}"

RDEPENDS_${PN} += "wpa-supplicant"

