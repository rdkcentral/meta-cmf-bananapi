# Add this new section
do_install:append() {
    install -m 0755 ${B}/tools/btattach ${D}${bindir}
}
