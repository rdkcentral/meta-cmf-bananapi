include ccsp_common_bananapi.inc
FILESEXTRAPATHS_append := "${THISDIR}/files:"

SRC_URI_append = " \
    file://cr-deviceprofile_bpi.xml \
"

do_install_append() {
    # Config files and scripts
    install -m 644 ${WORKDIR}/cr-deviceprofile_bpi.xml ${D}/usr/ccsp/cr-deviceprofile.xml
    install -m 644 ${WORKDIR}/cr-deviceprofile_bpi.xml ${D}/usr/ccsp/cr-ethwan-deviceprofile.xml
}
