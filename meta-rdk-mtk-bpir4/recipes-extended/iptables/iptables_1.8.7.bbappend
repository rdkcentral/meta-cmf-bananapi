RRECOMMENDS_${PN}_append += "kernel-module-xt-nat \
                             kernel-module-ipt-trigger"


FILESEXTRAPATHS_prepend:="${THISDIR}/files:"

SRC_URI_append = "file://0001-add-port-triggering-support.patch"
