SUMMARY = "RDK-WiFi-LIBHOSTAP for RDK CcspWiFiAgent components"
SUMMARY = "This recipe compiles and installs the Opensource hostapd as a dynamic library for RDK hostap authenticator"
SECTION = "base"
LICENSE = "BSD-3-Clause"
PATCH_SRC = "${@bb.utils.contains('DISTRO_FEATURES','kernel6-12','kernel_6_12',bb.utils.contains('DISTRO_FEATURES','kernel6-6','kernel_6_6','kernel_5_4',d), d)}"
FILESEXTRAPATHS:prepend:="${THISDIR}/files:"
FILESEXTRAPATHS:prepend := "${THISDIR}/files/2.11/${PATCH_SRC}:"
FILESEXTRAPATHS:prepend := "${@bb.utils.contains('DISTRO_FEATURES', 'kernel6-12', '${TOPDIR}/../meta-filogic/recipes-wifi/hostapd/files/kernelv6-patches:', bb.utils.contains('DISTRO_FEATURES','kernel6-6','${TOPDIR}/../meta-filogic/recipes-wifi/hostapd/files/kernel6-6-patches:', '', d), d)}"
PROVIDES = "rdk-wifi-libhostap"
RPROVIDES:${PN} = "rdk-wifi-libhostap"
DEPENDS += "libnl openssl"

DEPENDS:append = " ucode"

#inherit autotools pkgconfig
inherit pkgconfig

SRC_URI = "git://w1.fi/hostap.git;protocol=https;branch=main;destsuffix=${S}/source/hostap-${PV};name=${PV}"
SRC_URI_append_kernel6-6 = " file://banana-pi-sta-mlo-connection.patch "
SRCREV = "96e48a05aa0a82e91e3cab75506297e433e253d0"
SRCREV:kernel6-6 = "4b8ac10cb77c3d4dbf7ccefbe697dc0578da374c"
SRCREV:kernel6-12 = "53d12cd44da765ee446b2834aad92e9670319f8c"

LIC_FILES_CHKSUM = "file://source/hostap-2.11/README;md5=6e4b25e7d74bfc44a32ba37bdf5210a6"

EXTRA_OEMAKE:append = " \
    'BUILDDIR=${B}' \
    'PN=rdk-wifi-libhostap' \
    'MACHINE_IMAGE_NAME=${MACHINE_IMAGE_NAME}' \
    ${@bb.utils.contains('DISTRO_FEATURES', 'OneWifi', 'ONE_WIFI=y', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'CONFIG_IEEE80211BE', 'CONFIG_IEEE80211BE=y', '', d)} \
"
CFLAGS:append = " \
    -fcommon \
    -Wno-implicit-function-declaration \
"

SRC_URI += " \
    file://.config \
    file://2.11/libhostap.mk \
"
require files/2.11/${PATCH_SRC}/patches.inc

CFLAGS:append = " -D_PLATFORM_BANANAPI_R4_  -DCONFIG_SME -DCONFIG_GAS -DCONFIG_AP "

EMULATOR_FEATURE_ENABLED = "${@bb.utils.contains('DISTRO_FEATURES', 'Wifi-test-suite', '1', '0', d)}"

EMULATOR_HOSTAPD_PATCH = " file://2.11/nl80211_change.patch "
SRC_URI += "${@'${EMULATOR_HOSTAPD_PATCH}' if '${EMULATOR_FEATURE_ENABLED}' == '1' else ''}"

EXTRA_OECONF += " --disable-static --enable-shared "

S = "${UNPACKDIR}"

FILES:${PN} = " \
        ${libdir}/libhostap.so* \
"
EXTRA_OEMAKE += "${@bb.utils.contains('DISTRO_FEATURES', 'Wifi-test-suite', 'WIFI_EMULATOR=true', 'WIFI_EMULATOR=false', d)}"
do_hostapd_patch () {
    if ${@bb.utils.contains_any('DISTRO_FEATURES', 'kernel6-12 kernel6-6', 'true', 'false', d)}; then
       echo "CONFIG_OCV=y" >> ${UNPACKDIR}/.config
    fi
    install -m 0644 ${UNPACKDIR}/.config ${UNPACKDIR}/2.11/libhostap.mk ${S}/source/hostap-${PV}/hostapd/
    echo "include libhostap.mk" >> ${S}/source/hostap-${PV}/hostapd/Makefile
}

addtask hostapd_patch after do_patch before do_configure

do_configure:append () {
    oe_runmake -C ${S}/source/hostap-${PV}/hostapd clean_libhostap

    echo "CONFIG_TESTING_OPTIONS=y" >> ${S}/source/hostap-${PV}/hostapd/.config
    if ${@bb.utils.contains('DISTRO_FEATURES', 'kernel6-12', 'true', 'false', d)}; then
       echo "LIB_HDRS += ../src/common/nan_defs.h" >> ${S}/source/hostap-${PV}/hostapd/libhostap.mk
    fi
    echo "LIB_HDRS += ../src/common/nan.h" >> ${S}/source/hostap-${PV}/hostapd/libhostap.mk
    echo "LIB_HDRS += ../src/ap/ubus.h" >> ${S}/source/hostap-${PV}/hostapd/libhostap.mk
    echo "LIB_HDRS += ../src/ap/ucode.h" >> ${S}/source/hostap-${PV}/hostapd/libhostap.mk
    echo "LIB_HDRS += ../src/utils/ucode.h" >> ${S}/source/hostap-${PV}/hostapd/libhostap.mk
}

do_compile () {
    oe_runmake -C ${S}/source/hostap-${PV}/hostapd libhostap V=1
}

do_configure:prepend () {
    if ${@bb.utils.contains('DISTRO_FEATURES', 'Wifi-test-suite', 'true', 'false', d)}; then
        mv ${S}/source/hostap-${PV}/wpa_supplicant/rrm.c ${S}/source/hostap-${PV}/wpa_supplicant/rrm_test.c
    fi
}

do_install () {
    oe_runmake -C ${S}/source/hostap-${PV}/hostapd 'DESTDIR=${D}' install_libhostap
}

do_install:append () {
    if ${@bb.utils.contains('DISTRO_FEATURES', 'Wifi-test-suite', 'true', 'false', d)}; then
        cd ${S}/source/hostap-${PV}/wpa_supplicant && find . -type f -name "*.h" -exec install -D -m 0755 "{}" ${D}${includedir}/rdk-wifi-libhostap/src/"{}" \;
        mv ${D}${includedir}/rdk-wifi-libhostap/src/config.h ${D}${includedir}/rdk-wifi-libhostap/src/config_supplicant.h
    fi

    install -d ${D}${includedir}/rdk-wifi-libhostap/wpa_supplicant/
    install -m 0755 ${S}/source/hostap-${PV}/wpa_supplicant/*.h ${D}${includedir}/rdk-wifi-libhostap/wpa_supplicant
}
