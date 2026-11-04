# Removing ping binary from iputils, since busybox ping is preferred
do_install:append() {
    rm -f ${D}${base_bindir}/ping.${BPN}
    rm -f ${D}${base_bindir}/ping
    rm -f ${D}${base_bindir}/ping6
}

# Remove iputils-ping package entirely
PACKAGES:remove = "${PN}-ping"
PACKAGES:remove = "${PN}-ping6"
RDEPENDS:${PN}:remove = "${PN}-ping"
RDEPENDS:${PN}:remove = "${PN}-ping6"
INSANE_SKIP:${PN} += "installed-vs-shipped"
