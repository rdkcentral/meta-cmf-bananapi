# Removing ping binary from iputils, since busybox ping is preferred
do_install:append() {
    rm -f ${D}${base_bindir}/ping.${BPN}
    rm -f ${D}${base_bindir}/ping
}

# Remove iputils-ping package entirely
PACKAGES:remove = "${PN}-ping"
RDEPENDS:${PN}:remove = "${PN}-ping"
