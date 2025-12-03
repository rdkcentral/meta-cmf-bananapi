SUMMARY = "RDK-WiFi-LIBHOSTAP for RDK CcspWiFiAgent components"
SUMMARY = "This recipe compiles and installs the Opensource hostapd as a dynamic library for RDK hostap authenticator"
SECTION = "base"
LICENSE = "BSD-3-Clause"

PATCH_SRC = "${@bb.utils.contains('DISTRO_FEATURES', 'kernel6-6', 'kernel_6_6', 'kernel_5_4', d)}"
FILESEXTRAPATHS_prepend:="${THISDIR}/files:"
FILESEXTRAPATHS:prepend := "${THISDIR}/files/2.11/${PATCH_SRC}:"
PROVIDES = "rdk-wifi-libhostap"
RPROVIDES_${PN} = "rdk-wifi-libhostap"
DEPENDS += "libnl openssl"

DEPENDS_append = " ucode"

inherit autotools pkgconfig

SRC_URI = "git://w1.fi/hostap.git;protocol=https;branch=main;destsuffix=${S}/source/hostap-${PV};name=${PV}"
SRCREV = "96e48a05aa0a82e91e3cab75506297e433e253d0"
SRCREV_kernel6-6 = "4b8ac10cb77c3d4dbf7ccefbe697dc0578da374c"

LIC_FILES_CHKSUM = "file://source/hostap-2.11/README;md5=6e4b25e7d74bfc44a32ba37bdf5210a6"

EXTRA_OEMAKE_append = " \
    'BUILDDIR=${B}' \
    'PN=rdk-wifi-libhostap' \
    'MACHINE_IMAGE_NAME=${MACHINE_IMAGE_NAME}' \
    ${@bb.utils.contains('DISTRO_FEATURES', 'OneWifi', 'ONE_WIFI=y', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'CONFIG_IEEE80211BE', 'CONFIG_IEEE80211BE=y', '', d)} \
"
CFLAGS_append = " \
    -fcommon \
"

SRC_URI += " \
    file://.config \
    file://2.11/libhostap.mk \
"
require files/2.11/${PATCH_SRC}/patches.inc

CFLAGS_append = " -D_PLATFORM_BANANAPI_R4_  -DCONFIG_SME -DCONFIG_GAS -DCONFIG_AP "

EMULATOR_FEATURE_ENABLED = "${@bb.utils.contains('DISTRO_FEATURES', 'Wifi-test-suite', '1', '0', d)}"

EMULATOR_HOSTAPD_PATCH = " file://2.11/nl80211_change.patch "
SRC_URI += "${@'${EMULATOR_HOSTAPD_PATCH}' if '${EMULATOR_FEATURE_ENABLED}' == '1' else ''}"

EXTRA_OECONF += " --disable-static --enable-shared "

S = "${WORKDIR}/git/"

FILES_${PN} = " \
        ${libdir}/libhostap.so* \
"
EXTRA_OEMAKE += "${@bb.utils.contains('DISTRO_FEATURES', 'Wifi-test-suite', 'WIFI_EMULATOR=true', 'WIFI_EMULATOR=false', d)}"
do_hostapd_patch () {
    if ${@bb.utils.contains('DISTRO_FEATURES', 'kernel6-6', 'true', 'true', d)}; then
       echo "CONFIG_OCV=y" >> ${WORKDIR}/.config
    fi
    install -m 0644 ${WORKDIR}/.config ${WORKDIR}/2.11/libhostap.mk ${S}/source/hostap-${PV}/hostapd/
    echo "include libhostap.mk" >> ${S}/source/hostap-${PV}/hostapd/Makefile
}

addtask hostapd_patch after do_patch before do_configure

do_configure_append () {
    oe_runmake -C ${S}/source/hostap-${PV}/hostapd clean_libhostap

    echo "CONFIG_TESTING_OPTIONS=y" >> ${S}/source/hostap-${PV}/hostapd/.config
    echo "LIB_HDRS += ../src/common/nan.h" >> ${S}/source/hostap-${PV}/hostapd/libhostap.mk
    echo "LIB_HDRS += ../src/ap/ubus.h" >> ${S}/source/hostap-${PV}/hostapd/libhostap.mk
    echo "LIB_HDRS += ../src/ap/ucode.h" >> ${S}/source/hostap-${PV}/hostapd/libhostap.mk
    echo "LIB_HDRS += ../src/utils/ucode.h" >> ${S}/source/hostap-${PV}/hostapd/libhostap.mk
}

do_compile () {
    oe_runmake -C ${S}/source/hostap-${PV}/hostapd libhostap V=1
}

do_configure_prepend () {
    if ${@bb.utils.contains('DISTRO_FEATURES', 'Wifi-test-suite', 'true', 'false', d)}; then
        mv ${S}/source/hostap-${PV}/wpa_supplicant/rrm.c ${S}/source/hostap-${PV}/wpa_supplicant/rrm_test.c
    fi
}

do_install () {
    oe_runmake -C ${S}/source/hostap-${PV}/hostapd 'DESTDIR=${D}' install_libhostap
}

do_install_append () {
    if ${@bb.utils.contains('DISTRO_FEATURES', 'Wifi-test-suite', 'true', 'false', d)}; then
        cd ${S}/source/hostap-${PV}/wpa_supplicant && find . -type f -name "*.h" -exec install -D -m 0755 "{}" ${D}${includedir}/rdk-wifi-libhostap/src/"{}" \;
        mv ${D}${includedir}/rdk-wifi-libhostap/src/config.h ${D}${includedir}/rdk-wifi-libhostap/src/config_supplicant.h
    fi

    install -d ${D}${includedir}/rdk-wifi-libhostap/wpa_supplicant/
    install -m 0755 ${S}/source/hostap-${PV}/wpa_supplicant/*.h ${D}${includedir}/rdk-wifi-libhostap/wpa_supplicant
}
