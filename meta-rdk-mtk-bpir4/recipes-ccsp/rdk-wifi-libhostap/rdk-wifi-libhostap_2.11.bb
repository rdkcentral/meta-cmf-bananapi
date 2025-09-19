SUMMARY = "RDK-WiFi-LIBHOSTAP for RDK CcspWiFiAgent components"
SUMMARY = "This recipe compiles and installs the Opensource hostapd as a dynamic library for RDK hostap authenticator"
SECTION = "base"
LICENSE = "BSD-3-Clause"

FILESEXTRAPATHS_prepend:="${THISDIR}/files:"
PROVIDES = "rdk-wifi-libhostap"
RPROVIDES_${PN} = "rdk-wifi-libhostap"
DEPENDS += "libnl openssl"

DEPENDS_append = " ucode"

inherit autotools pkgconfig

SRC_URI = "git://w1.fi/hostap.git;protocol=https;branch=main;destsuffix=${S}/source/hostap-${PV};name=${PV}"
SRCREV = "96e48a05aa0a82e91e3cab75506297e433e253d0"

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
    file://2.11/Bpi_rdkwifilibhostap_2_11_changes.patch \
    file://2.11/0001-mtk-hostapd-patch-all-in-one.patch;patchdir=source/hostap-2.11/ \
    file://2.11/comcast_changes_merged_to_source_2_11.patch \
    file://2.11/onewifi_lib_2_12.patch \
    file://2.11/RDKB-53254_Telemetry_2.11.patch \
    file://2.11//wps_term_session.patch \
    file://2.11//cmxb7_dfs.patch \
    file://2.11//cohosted_bss_param_211.patch \
    file://2.11//ht_rifs_211.patch \
    file://2.11//vht_oper_basic_mcs_set_211.patch \
    file://2.11//tx_pwr_envelope_211.patch \
    file://2.11//pwr_constraint_211.patch \
    file://2.11//supported_op_classes_211.patch \
    file://2.11//he_2ghz_40mghz_bw_211.patch \
    file://2.11//rnr_col_211.patch \
    file://2.11//tpc_report_211.patch \
    file://2.11//driver_aid_211.patch \
    file://2.11//sta_assoc_req.patch \
    file://2.11//wps_event_notify_cb.patch \
    file://2.11//nl_attr_rx_phy_rate_info.patch \
    file://2.11/hostapd_bss_link_deinit.patch \
    file://2.11/radius_failover_2_11.patch \
    file://2.11/mbssid_support_2_11.patch \
    file://2.11/export_valid_chan_func_2_11.patch \
    file://2.11/increase_eapol_timeout.patch \
    file://2.11/Dynamic_NAS_IP_Update_2_11.patch \
    file://2.11/patch_issues_with2_12.patch \
    file://2.11/wpa3_compatibility_hostap_2_11.patch \
    file://2.11/wpa3_compatibility_telem_hostap_2_11.patch \
    file://2.11/0002-mtk-disable-sae-commit-status.patch \
    file://2.11/mlo_configuration.patch \
    file://2.11/open_auth_workaround.patch \
    file://2.11/mdu_radius_psk_auth_2_11.patch \
    file://2.11/supplicant_new.patch \
    file://2.11/bpi.patch \
    "

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
