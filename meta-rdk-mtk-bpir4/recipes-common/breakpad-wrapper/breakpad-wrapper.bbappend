
do_prepare_recipe_sysroot[depends] += "breakpad-native:do_populate_sysroot"

CXXFLAGS += "-I${WORKDIR}/recipe-sysroot-native/usr/include/breakpad"

LDFLAGS:append = "-lbreakpad_client"
BBCLASSEXTEND = "native"
