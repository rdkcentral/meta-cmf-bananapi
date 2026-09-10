FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI += " file://uploadRRDLogs.sh"
do_install_append () {
 sed -i "s/ utopia.service//" ${D}${systemd_unitdir}/system/remote-debugger.service
 install -m 0755 ${WORKDIR}/uploadRRDLogs.sh ${D}${base_libdir}/rdk/uploadRRDLogs.sh
}
SYSTEMD_AUTO_ENABLE:${PN} = "enable"
