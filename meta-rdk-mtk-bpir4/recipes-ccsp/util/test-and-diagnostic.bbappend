include recipes-ccsp/ccsp/ccsp_common_bananapi.inc


do_install_append () {
       install -m 0755 ${S}/scripts/speedtest.sh ${D}/usr/ccsp/tad
}
