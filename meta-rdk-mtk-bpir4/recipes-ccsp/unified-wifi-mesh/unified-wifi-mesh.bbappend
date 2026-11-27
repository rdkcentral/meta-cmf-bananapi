# Bridge interface for STP monitoring on BPI platform.
EASYMESH_STP_BRIDGE ?= "brlan0"

# STP bridge priorities (decimal).
EASYMESH_STP_GATEWAY_PRIORITY ?= "4096"
EASYMESH_STP_EXTENDER_PRIORITY ?= "32768"

do_install:append() {
    install -d ${D}${sysconfdir}/default
    echo "EASYMESH_STP_BRIDGE=${EASYMESH_STP_BRIDGE}" > ${D}${sysconfdir}/default/uwm-defaults
    echo "EASYMESH_STP_GATEWAY_PRIORITY=${EASYMESH_STP_GATEWAY_PRIORITY}" >> ${D}${sysconfdir}/default/uwm-defaults
    echo "EASYMESH_STP_EXTENDER_PRIORITY=${EASYMESH_STP_EXTENDER_PRIORITY}" >> ${D}${sysconfdir}/default/uwm-defaults
}

FILES:${PN} += "${sysconfdir}/default/uwm-defaults"

