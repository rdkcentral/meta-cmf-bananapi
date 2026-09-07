include ccsp_common_bananapi.inc

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI:append = "file://0001-Implement-WAN-interface-handling-for-multiple-platfo.patch"
