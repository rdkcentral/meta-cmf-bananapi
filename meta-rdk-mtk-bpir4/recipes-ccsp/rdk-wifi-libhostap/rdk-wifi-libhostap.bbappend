FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

LIC_FILES_CHKSUM_remove = "file://source/hostap-2.10/README;md5=e3d2f6c2948991e37c1ca4960de84747"
LIC_FILES_CHKSUM = "file://source/hostap-2.11/README;md5=6e4b25e7d74bfc44a32ba37bdf5210a6"

SRC_URI_remove = " file://Rpi_rdkwifilibhostap_changes.patch"
SRC_URI_remove = " file://fixed_6G_wrong_freq.patch"
SRC_URI_append = " ${@bb.utils.contains('DISTRO_FEATURES', 'HOSTAPD_2_10', 'file://2.10/wpa3_compatibility_hostap_2_10.patch', '', d)}"
SRC_URI_append = " ${@bb.utils.contains('DISTRO_FEATURES', 'HOSTAPD_2_11', 'file://2.11/Bpi_rdkwifilibhostap_2_11_changes.patch', 'file://2.10/Bpi_rdkwifilibhostap_2_10_changes.patch', d)}"

DEPENDS_append = " ucode"

#Upstep from hostapd 2.11 to hostapd 2.12-devel with following commit
SRCREV_2.11 = "96e48a05aa0a82e91e3cab75506297e433e253d0"

SRC_URI_append = " \
${@bb.utils.contains('DISTRO_FEATURES', 'HOSTAPD_2_11', '\
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
file://2.11/onewifi_crash_with_2_12.patch ',\
 ' ', d)}"

do_configure_append() {
${@bb.utils.contains('DISTRO_FEATURES', 'HOSTAPD_2_11', 'echo "CONFIG_TESTING_OPTIONS=y" >> ${S}/source/hostap-${HOSTAPD_PV}/hostapd/.config', '',d)}
${@bb.utils.contains('DISTRO_FEATURES', 'HOSTAPD_2_11', 'echo "LIB_HDRS += ../src/common/nan.h" >> ${S}/source/hostap-${HOSTAPD_PV}/hostapd/libhostap.mk', '',d)}
${@bb.utils.contains('DISTRO_FEATURES', 'HOSTAPD_2_11', 'echo "LIB_HDRS += ../src/ap/ubus.h" >> ${S}/source/hostap-${HOSTAPD_PV}/hostapd/libhostap.mk', '',d)}
${@bb.utils.contains('DISTRO_FEATURES', 'HOSTAPD_2_11', 'echo "LIB_HDRS += ../src/ap/ucode.h" >> ${S}/source/hostap-${HOSTAPD_PV}/hostapd/libhostap.mk', '',d)}
${@bb.utils.contains('DISTRO_FEATURES', 'HOSTAPD_2_11', 'echo "LIB_HDRS += ../src/utils/ucode.h" >> ${S}/source/hostap-${HOSTAPD_PV}/hostapd/libhostap.mk', '',d)}
}

CFLAGS_append = " -D_PLATFORM_BANANAPI_R4_"
