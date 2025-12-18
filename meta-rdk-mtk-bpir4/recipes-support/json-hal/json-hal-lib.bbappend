FILES_SOLIBSDEV = ""
FILES:${PN} += "${libdir}/* \
                ${bindir}/* "
INSANE_SKIP:${PN} += "dev-so"
