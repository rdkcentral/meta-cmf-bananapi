DEPENDS += "gdbm"

RDEPENDS:${PN}-module-gdbm-file += "gdbm"
RDEPENDS:${PN}-module-ndbm-file += "gdbm gdbm-compat"
