SUMMARY = "GW LAN Refresh application for refreshing the LAN clients"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=175792518e4ac015ab6696d16c4f607e"


# Fetch the source code
SRC_URI = "${CMF_GITHUB_ROOT}/broadband-utils.git;protocol=https;branch=develop"

SRCREV = "8dc573c6b82ba5e164cf1287d4ab5c659bd38641"

S = "${WORKDIR}/git"

DEPENDS = "rdkb-halif-ethsw hal-ethsw rbus"


LDFLAGS = " -lrbus -lhal_ethsw"
CFLAGS = " \
    -I${STAGING_INCDIR}/rbus \
    -I${STAGING_INCDIR}/ccsp \
"

do_compile() {
    ${CC} ${S}/gw-lan-refresh/source/*.c ${LDFLAGS} ${CFLAGS} -o gw_lan_refresh
}

do_install() {
    # Create all directories first
    install -d ${D}${bindir}
    install -m 0755 gw_lan_refresh ${D}${bindir}/gw_lan_refresh
}
