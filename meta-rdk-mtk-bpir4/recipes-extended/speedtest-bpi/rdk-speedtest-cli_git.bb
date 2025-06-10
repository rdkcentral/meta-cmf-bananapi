SUMMARY = "RDK Speed Test CLI tool"
DESCRIPTION = "Command line tool for running iperf3 speed tests and updating RDK diagnostic parameters"
SECTION = "net"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=86d3f3a95c324c9479bd8986968f4327"

SRC_URI = "${CMF_GITHUB_ROOT}/rdk-speedtest-cli.git;protocol=git;nobranch=1"
SRCREV = "f6a906305302aea3ebfd037b0a58f8ea54a9c9ae"
PV = "1.0.0"
CFLAGS_append += " -DRBUS_BUILD_INTEGRATED"
CFLAGS_append += " -DRBUS_BUILD_FLAG_ENABLE"
LDFLAGS_append = "-liperf -ltelemetry_msgsender -lrbus -lrtMessage -lrbuscore"

S = "${WORKDIR}/git"

inherit autotools ${@bb.utils.contains("DISTRO_FEATURES", "kirkstone", "python3native", "pythonnative", d)}

DEPENDS = "iperf3 telemetry rbus"

CFLAGS_append = " \
    -I ${RECIPE_SYSROOT}/usr/include \
    -I ${RECIPE_SYSROOT}/usr/include/rtmessage \
    -I ${RECIPE_SYSROOT}/usr/include/rbus \
    "


do_compile() {
        ${CC} ${S}/source/rdk-speedtest-cli.c ${CFLAGS} ${LDFLAGS} -I ${S}/include -o speedtest-client
}


do_install() {
        install -d ${D}${bindir}
        install -m 0755 speedtest-client ${D}${bindir}/speedtest-client
}
