BBCLASSEXTEND += "native"

CFLAGS += "-Wno-error=use-after-free"
#TARGET_CFLAGS:append = "-Wno-format-security -Wno-stringop-truncation -Wno-stringop-overflow"
CFLAGS:append = "-Wno-format-security -Wno-stringop-truncation -Wno-stringop-overflow"

DEPENDS:append:class-native = " msgpack-c-native linenoise-native"

EXTRA_OECMAKE += "\
  -DCMAKE_SYSROOT=${STAGING_DIR_TARGET} \
  -DMSGPACK_LIBRARIES=${STAGING_DIR_TARGET}/usr/lib/libmsgpack-c.so \
  -DMSGPACK_INCLUDE_DIRS=${STAGING_DIR_TARGET}/usr/include \
  -DLINENOISE_LIBRARIES=${STAGING_DIR_TARGET}/usr/lib/liblinenoise.so \
  -DLINENOISE_INCLUDE_DIRS=${STAGING_DIR_TARGET}/usr/include \
"

EXTRA_OECMAKE:append:class-native = "\
  -DMSGPACK_INCLUDE_DIRS=${STAGING_DIR_NATIVE}/usr/include \
  -DMSGPACK_LIBRARIES=${STAGING_DIR_NATIVE}/usr/lib/libmsgpack-c.so \
  -DLINENOISE_INCLUDE_DIRS=${STAGING_DIR_NATIVE}/usr/include \
  -DLINENOISE_LIBRARIES=${STAGING_DIR_NATIVE}/usr/lib/liblinenoise.so \
"

FILES:${PN} += "${systemd_unitdir}/system/*"

