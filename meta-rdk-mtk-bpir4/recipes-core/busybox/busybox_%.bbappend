FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI += " file://rdkb-bpi.cfg"
do_install_append() {
        rm ${D}${sysconfdir}/init.d/syslog
}

FILES_${PN}-syslog_remove = "${sysconfdir}/init.d/syslog"
