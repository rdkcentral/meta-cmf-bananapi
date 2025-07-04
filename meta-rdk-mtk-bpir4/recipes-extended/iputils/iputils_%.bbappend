# Removing ping binary from iputils, since busybox ping is preferred
do_install_append() {
    rm -f ${D}${base_bindir}/ping.${BPN}
    rm -f ${D}${base_bindir}/ping
}

# Remove iputils-ping package entirely
PACKAGES_remove = "${PN}-ping"
RDEPENDS_${PN}_remove = "${PN}-ping"
