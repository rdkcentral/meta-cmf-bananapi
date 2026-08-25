SUMMARY = "RDK Speed Test CLI tool"
DESCRIPTION = "Command line tool for running iperf3 speed tests and updating RDK diagnostic parameters"
SECTION = "net"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=86d3f3a95c324c9479bd8986968f4327"

SRC_URI = "${CMF_GITHUB_ROOT}/rdk-speedtest-cli;protocol=https;nobranch=1"
SRCREV = "f6a906305302aea3ebfd037b0a58f8ea54a9c9ae"
PV = "1.0.0"
CFLAGS:append += " -DRBUS_BUILD_INTEGRATED"
CFLAGS:append += " -DRBUS_BUILD_FLAG_ENABLE"
LDFLAGS:append = "-liperf -ltelemetry_msgsender -lrbus -lrtMessage -lrbuscore"


inherit autotools ${@bb.utils.contains_any("DISTRO_FEATURES", "kirkstone wrynose", "python3native", "pythonnative", d)}

DEPENDS = "iperf3 telemetry rbus"

CFLAGS:append = " \
    -I ${RECIPE_SYSROOT}/usr/include \
    -I ${RECIPE_SYSROOT}/usr/include/rtmessage \
    -I ${RECIPE_SYSROOT}/usr/include/rbus \
    "


do_compile() {
        ${CC} ${S}/source/rdk-speedtest-cli.c ${CFLAGS} ${LDFLAGS} -I ${S}/include -o RefSpeedtestClient
}


do_install() {
        install -d ${D}${bindir}
        install -m 0755 RefSpeedtestClient ${D}${bindir}/RefSpeedtestClient
}
