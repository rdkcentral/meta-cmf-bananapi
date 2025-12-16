RRECOMMENDS:${PN}:append = "kernel-module-xt-nat \
                             kernel-module-ipt-trigger"

FILESEXTRAPATHS:prepend:="${THISDIR}/files:"

SRC_URI:append = "file://0001-add-port-triggering-support.patch"
