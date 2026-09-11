#The changes below need to be removed once it’s merged in meta-rdk-broadband
MATH_UTILS_COMPILE = "${@bb.utils.contains('DISTRO_FEATURES', 'BuildFromTip', '1', '0', d)}"

do_compile:append() {
   if [ "${MATH_UTILS_COMPILE}" = "1" ]; then
      oe_runmake -C source/utils/math_utils
   fi
}

do_install:append() {
   if [ "${MATH_UTILS_COMPILE}" = "1" ]; then
      oe_runmake -C source/utils/math_utils DESTDIR="${D}" install
      install -d ${D}${includedir}/ccsp/math_utils
      install -D -m 0644 ${S}/include/run_qmgr.h ${D}${includedir}/ccsp/run_qmgr.h
      install -m 0644 ${S}/source/utils/math_utils/inc/* ${D}${includedir}/ccsp/math_utils/
   fi
}
