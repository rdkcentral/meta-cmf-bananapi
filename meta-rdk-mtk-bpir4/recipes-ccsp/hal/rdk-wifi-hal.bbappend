SRC_URI_remove = "git://github.com/rdkcentral/rdk-wifi-hal.git;protocol=https;branch=main;name=rdk-wifi-hal"

SRC_URI += "git://github.com/rdkcentral/rdk-wifi-hal.git;protocol=https;branch=MLOdemo;name=rdk-wifi-hal"
SRCREV_rdk-wifi-hal = "a8bdea1dce2761060f54e4dfe8e69af19f3d9b1f"

CFLAGS_append = " -D_PLATFORM_BANANAPI_R4_  -DBANANA_PI_PORT  -DFEATURE_SINGLE_PHY -DCONFIG_HW_CAPABILITIES "
CFLAGS_append_kirkstone = " -fcommon"
CFLAGS_remove = "-DCONFIG_MBO"
EXTRA_OECONF_append = " ${@bb.utils.contains('DISTRO_FEATURES', 'OneWifi', ' ONE_WIFIBUILD=true ', '', d)}"
EXTRA_OECONF_append = " ${@bb.utils.contains('DISTRO_FEATURES', 'OneWifi', ' BANANA_PI_PORT=true ', '', d)}"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += " \
  file://InterfaceMap.json \
  file://wifihal_2_12hostap.patch;apply=no \
  file://nl_recv_core_2_12.patch;apply=no \
  file://wifi_core_wrt_Host2_12.patch;apply=no \
"
do_hal_patches() {
        cd ${WORKDIR}/git
        if [ ! -e hal_patch_applied ]; then
            patch -p1 < ${WORKDIR}/wifihal_2_12hostap.patch
            patch -p1 < ${WORKDIR}/nl_recv_core_2_12.patch
            patch -p1 < ${WORKDIR}/wifi_core_wrt_Host2_12.patch
            touch hal_patch_applied
        fi
}
addtask hal_patches after do_unpack before do_compile

# Install InterfaceMap.json in /nvram
do_install_append() {
  install -d ${D}/nvram
  install -m 0644 ${WORKDIR}/InterfaceMap.json ${D}/nvram/InterfaceMap.json
}

FILES_${PN} += " \
  /nvram/InterfaceMap.json \
"
