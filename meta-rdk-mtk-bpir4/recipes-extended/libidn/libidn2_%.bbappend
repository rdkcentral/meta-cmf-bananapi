FILES:${PN}:append:class-nativesdk:wrynose = " ${includedir}"

do_install:append:class-nativesdk:wrynose() {
    rm -rf ${D}${bindir}
    rm -rf ${D}${datadir}
}
