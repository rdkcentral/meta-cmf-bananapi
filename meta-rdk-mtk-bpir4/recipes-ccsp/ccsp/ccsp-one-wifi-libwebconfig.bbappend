do_compile:append() {
   oe_runmake -C source/utils/math_utils
}

do_install:append() {
   oe_runmake -C source/utils/math_utils DESTDIR="${D}" install
   install -d ${D}${includedir}/ccsp/math_utils
   install -D -m 0644 ${S}/include/run_qmgr.h ${D}${includedir}/ccsp/run_qmgr.h
   install -m 0644 ${S}/source/utils/math_utils/inc/* ${D}${includedir}/ccsp/math_utils/
}
