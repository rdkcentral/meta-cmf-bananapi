include ccsp_common_bananapi.inc
FILESEXTRAPATHS:append := "${THISDIR}/files:"

SRC_URI:append = " \
    file://cr-deviceprofile_bpi.xml \
"

do_install:append() {
    # Config files and scripts
    install -m 644 ${UNPACKDIR}/cr-deviceprofile_bpi.xml ${D}/usr/ccsp/cr-deviceprofile.xml
    install -m 644 ${UNPACKDIR}/cr-deviceprofile_bpi.xml ${D}/usr/ccsp/cr-ethwan-deviceprofile.xml
}
CFLAGS:append:wrynose = " -Wno-error=header-guard"
