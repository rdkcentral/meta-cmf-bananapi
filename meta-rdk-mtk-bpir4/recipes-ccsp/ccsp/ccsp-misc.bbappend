include ccsp_common_bananapi.inc
inherit breakpad-wrapper

CFLAGS_aarch64_append = "-Werror=format-truncation=1"
DEPENDS += "${@bb.utils.contains('DISTRO_FEATURES','bridgeUtilsBin','halinterface','',d)}"
DEPENDS += "${@bb.utils.contains('DISTRO_FEATURES','bridgeUtilsBin','hal-bridgeutil','',d)}"
DEPENDS += "${@bb.utils.contains('DISTRO_FEATURES','bridgeUtilsBin','breakpad','',d)}"
DEPENDS += "${@bb.utils.contains('DISTRO_FEATURES','bridgeUtilsBin','breakpad-wrapper','',d)}"
DEPENDS += "${@bb.utils.contains('DISTRO_FEATURES','bridgeUtilsBin','ovs-agent','',d)}"

CFLAGS += " -DDHCPV4_CLIENT_UDHCPC -DDHCPV6_CLIENT_DIBBLER -DUDHCPC_RUN_IN_BACKGROUND"
EXTRA_OECONF += "${@bb.utils.contains("DISTRO_FEATURES", "bridgeUtilsBin", " --enable-bridgeUtilsBin=yes ", " ", d)}"

CFLAGS_append = " ${@bb.utils.contains('DISTRO_FEATURES', 'OneWifi', '-DRDK_ONEWIFI', '', d)}"
LDFLAGS_append = "${@bb.utils.contains('DISTRO_FEATURES','bridgeUtilsBin',' -lOvsAgentApi ',' ',d)}"

BREAKPAD_BIN_append = "${@bb.utils.contains('DISTRO_FEATURES','bridgeUtilsBin','bridgeUtils','',d)}"

# generating minidumps

PACKAGECONFIG_append = "${@bb.utils.contains('DISTRO_FEATURES','bridgeUtilsBin','breakpad',' ',d)}"
