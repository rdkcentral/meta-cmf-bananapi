DESCRIPTION = "GSM Audio Library"
SECTION = "libs"
PRIORITY = "optional"
LICENSE = "ISC"
LIC_FILES_CHKSUM = "file://COPYRIGHT;md5=fc1372895b173aaf543a122db37e04f5"

PV = "1.0.19"

SRC_URI = "\
    http://www.quut.com/gsm/gsm-${PV}.tar.gz \
    file://dyn-lib.patch \
"
SRC_URI[sha256sum] = "4903652f68a8c04d0041f0d19b1eb713ddcd2aa011c5e595b3b8bca2755270f6"
S = "${WORKDIR}/gsm-1.0-pl19"

EXTRA_OEMAKE = "\
    CC='${CC}' \
    LD='${CC}' \
    LN='ln -s' \
    RANLB='${RANLIB}' \
    CCFLAGS='${CFLAGS} -fPIC -DNeedFunctionPrototypes=1 -c' \
    GSM_INSTALL_LIB='$(DESTDIR)${libdir}' \
    GSM_INSTALL_INC='$(DESTDIR)${includedir}/gsm' \
    GSM_INSTALL_MAN='$(DESTDIR)${mandir}' \
    TOAST_INSTALL_BIN='$(DESTDIR)${bindir}' \
    TOAST_INSTALL_MAN='$(DESTDIR)${mandir}' \
    GSM_INSTALL_ROOT=x \
    TOAST_INSTALL_ROOT=x \
"

PARALLEL_MAKE = ""

do_install() {
	install -d -m 0755 ${D}${libdir} ${D}${bindir} ${D}${mandir} ${D}${includedir}/gsm
	oe_runmake install DESTDIR='${D}'
}

PACKAGES =+ "${PN}-bin"
FILES:${PN}-bin = "${bindir}/*"

BBCLASSEXTEND = "native nativesdk"

