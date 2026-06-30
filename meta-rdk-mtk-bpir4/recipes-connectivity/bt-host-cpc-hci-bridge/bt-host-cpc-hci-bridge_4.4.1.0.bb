DESCRIPTION = "Bluetooth CPC HCI Bridge"
LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://${WORKDIR}/git/gsdk/License.txt;md5=9a041f41aad5520b22ab2bb033c11e3c"

# GSDK path definition
GSDK_DIR = "${WORKDIR}/git/gsdk"
BT_BRIDGE_DIR = "${GSDK_DIR}/app/bluetooth/example_host/bt_host_cpc_hci_bridge"

SRC_URI = "git://github.com/SiliconLabs/gecko_sdk.git;protocol=https;branch=gsdk_4.4;destsuffix=git/gsdk;name=gsdk"
SRCREV_gsdk = "9ad9e19638a2d0ce01ce21d32f5049c5f1b21d70"

SRC_URI += "file://bt-host-cpc-hci-bridge.service \
            file://bt-host-cpc-hci-bridge-attach.service \
           "

DEPENDS += "cpcd"
RDEPENDS:${PN} += "cpcd (= 4.4.1.0-r0) bluez5-noinst-tools"

S = "${BT_BRIDGE_DIR}"

inherit pkgconfig systemd
do_unpack[network] = "1"
# Ensure we're using the correct toolchain
TOOLCHAIN = "gcc"
INHIBIT_DEFAULT_DEPS = "1"
DEPENDS += "virtual/${TARGET_PREFIX}gcc virtual/${TARGET_PREFIX}g++ virtual/libc"

# Basic compilation flags
CFLAGS = "${TARGET_CFLAGS} -D_DEFAULT_SOURCE -D_BSD_SOURCE -DHOST_TOOLCHAIN -DPOSIX -DSL_CATALOG_APP_LOG_PRESENT"

EXTRA_OEMAKE = "\
    CPC=1 \
    CC='${CC}' \
    CROSS_COMPILE=${TARGET_PREFIX} \
    CFLAGS='${CFLAGS} \
            -I${STAGING_INCDIR} \
            -I${STAGING_INCDIR}/sl_cpc \
            -I${GSDK_DIR}/app/bluetooth/common_host/iostream_mock \
            -I${GSDK_DIR}/app/bluetooth/common_host/app_log \
            -I${GSDK_DIR}/app/bluetooth/common_host/app_log/config \
            -I${GSDK_DIR}/platform/common/inc \
            -I${GSDK_DIR}/protocol/bluetooth/bgstack/ll/utils/hci_packet/inc \
            -fno-short-enums -Wall -std=c99' \
    LDFLAGS='${LDFLAGS}' \
"

do_configure[noexec] = "1"

do_compile() {
    oe_runmake
}

do_install() {
    # Install binary from the exe directory
    install -d ${D}${bindir}
    install -m 0755 ${S}/exe/bt_host_cpc_hci_bridge ${D}${bindir}

    # Install systemd services
    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/bt-host-cpc-hci-bridge.service ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/bt-host-cpc-hci-bridge-attach.service ${D}${systemd_system_unitdir}
}

FILES:${PN} += "${systemd_system_unitdir}"

SYSTEMD_SERVICE:${PN} = "bt-host-cpc-hci-bridge.service bt-host-cpc-hci-bridge-attach.service"
SYSTEMD_AUTO_ENABLE = "enable"
