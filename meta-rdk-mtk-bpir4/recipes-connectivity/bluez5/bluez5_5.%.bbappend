# Add this new section
do_install_append() {
    install -m 0755 ${B}/tools/btattach ${D}${bindir}
}
