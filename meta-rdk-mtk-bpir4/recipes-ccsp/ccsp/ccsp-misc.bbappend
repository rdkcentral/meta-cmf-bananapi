include ccsp_common_bananapi.inc

CFLAGS_aarch64_append = "-Werror=format-truncation=1 -DDHCPV6_CLIENT_DIBBLER -DDHCPV4_CLIENT_UDHCPC -DUDHCPC_RUN_IN_BACKGROUND"

CFLAGS_append = "${@bb.utils.contains('DISTRO_FEATURES', 'rdkb_wan_manager', ' -DDHCPV6_CLIENT_DIBBLER ', '', d)}"
CFLAGS_append = "${@bb.utils.contains('DISTRO_FEATURES', 'rdkb_wan_manager', ' -DDHCPV4_CLIENT_UDHCPC ', '', d)}"
CFLAGS_append = "${@bb.utils.contains('DISTRO_FEATURES', 'rdkb_wan_manager', ' -DUDHCPC_RUN_IN_BACKGROUND ', '', d)}"

