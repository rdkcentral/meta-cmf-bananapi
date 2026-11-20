CFLAGS:append = " \
    -Wno-error=implicit-function-declaration \
"
INSANE_SKIP:${PN} += "installed-vs-shipped"
