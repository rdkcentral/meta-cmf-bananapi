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
    ln -sf ${S}/devices_bpi/source/wifi/wifi_hal.c ${S}/wifi_hal.c
    ln -sf ${S}/devices_bpi/source/wifi/client_wifi_hal.c ${S}/client_wifi_hal.c
    ln -sf ${S}/devices_bpi/source/wifi/wifi_hostapd_interface.c ${S}/wifi_hostapd_interface.c
    ln -sf ${S}/devices_bpi/source/wifi/rpi_wifi_hal_assoc_devices_details.c ${S}/rpi_wifi_hal_assoc_devices_details.c
    ln -sf ${S}/devices_bpi/source/wifi/rpi_wifi_hal_version_3.c ${S}/rpi_wifi_hal_version_3.c
    ln -sf ${S}/devices_bpi/source/wifi/wifi_hal_rpi.h ${S}/wifi_hal_rpi.h
    ln -sf ${S}/devices_bpi/source/wifi/Makefile.am ${S}/Makefile.am
    sed -i "s/wlan0/wifi0/g" ${S}/wifi_hal.c
    sed -i "s/wlan0/wifi0/g" ${S}/rpi_wifi_hal_assoc_devices_details.c
    sed -i "s/wlan1/wifi1/g" ${S}/wifi_hal.c
    sed -i "s/wlan1/wifi1/g" ${S}/rpi_wifi_hal_assoc_devices_details.c
    sed -i "s/wlan%d/wifi%d/g" ${S}/wifi_hal.c
    sed -i "s/wlan%d/wifi%d/g" ${S}/rpi_wifi_hal_assoc_devices_details.c
}

do_install_append(){
    install -d ${D}/usr/bin
    install -m 777 ${B}/wifihal ${D}/usr/bin/
}

CFLAGS_append = " -DWIFI_HAL_VERSION_3 "
CFLAGS_append = " ${@bb.utils.contains('DISTRO_FEATURES', 'OneWifi', ' -D_ONE_WIFI_ ', '', d)}"

RDEPENDS_${PN} += "wpa-supplicant"

