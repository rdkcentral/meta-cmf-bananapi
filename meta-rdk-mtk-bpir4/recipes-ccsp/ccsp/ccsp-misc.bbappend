include ccsp_common_bananapi.inc

CFLAGS_aarch64_append = "-Werror=format-truncation=1"

CFLAGS += " -DDHCPV4_CLIENT_UDHCPC -DDHCPV6_CLIENT_DIBBLER -DUDHCPC_RUN_IN_BACKGROUND"
