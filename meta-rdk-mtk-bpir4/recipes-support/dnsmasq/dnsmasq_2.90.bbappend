FILESEXTRAPATHS:prepend := "${THISDIR}/${BPN}-${PV}:"

# Warning: RDK-B requires these changes to dnsmasq. If an RDK-B based build
# is using an alternative version of dnsmasq (a version to which these patches
# have not been ported) then expect runtime issues or missing functionality.

do_install:append() {
    sed -i -- 's/listen-address=127.0.0.1/#listen-address=127.0.0.1/g' ${D}${sysconfdir}/dnsmasq.conf
    sed -i -- 's/bind/#Remove this statement/g' ${D}${sysconfdir}/dnsmasq.conf
}

INSANE_SKIP:${PN} += "file-rdeps" 

