FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_remove = "https://w1.fi/cgit/hostap/snapshot/hostap_2_9.tar.gz"
SRC_URI += "https://w1.fi/releases/hostapd-2.9.tar.gz"
SRC_URI[sha256sum] = "881d7d6a90b2428479288d64233151448f8990ab4958e0ecaca7eeb3c9db2bd7"

SRC_URI_append = " file://Bpi_rdkwifilibhostap_changes.patch "

CFLAGS_append = " -D_PLATFORM_BANANAPI_R4_"

do_dir_align_prepend() {
    mkdir -p ${WORKDIR}/hostap_2_9 
}

do_dir_align_append() {
    rm -rf ${WORKDIR}/hostap_2_9 ${S}/source/hostap-2.9 
    mv ${WORKDIR}/hostapd-2.9 ${S}/source/hostap-2.9
}

