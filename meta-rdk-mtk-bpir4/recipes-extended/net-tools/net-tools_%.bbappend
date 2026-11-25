
#removes only ifconfig from the net-tools package
do_install:append:wrynose() {
    rm -f ${D}${bindir}/ifconfig
}
