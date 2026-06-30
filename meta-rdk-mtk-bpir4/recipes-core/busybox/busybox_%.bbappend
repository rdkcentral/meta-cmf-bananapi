FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
SRC_URI += " file://rdkb-bpi.cfg"
do_install:append() {
        rm ${D}${sysconfdir}/init.d/syslog
}

FILES:${PN}-syslog:remove = "${sysconfdir}/init.d/syslog"
