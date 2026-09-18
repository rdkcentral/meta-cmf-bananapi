# Add this new section
do_install:append() {
    install -m 0755 ${B}/tools/btattach ${D}${bindir}
}

ERROR_QA:remove = "patch-fuzz"
WARN_QA:append = " patch-fuzz"

