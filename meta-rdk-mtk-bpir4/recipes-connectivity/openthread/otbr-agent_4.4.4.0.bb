DESCRIPTION = "OpenThread Border Router Agent"
HOMEPAGE = "https://github.com/openthread/ot-br-posix"


LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://LICENSE;md5=87109e44b2fda96a8991f27684a7349c \
                    file://third_party/openthread/repo/LICENSE;md5=543b6fe90ec5901a683320a36390c65f \
"

# OTBR and openthread dir paths inside the gecko sdk
GSDK_DIR="${WORKDIR}/git/gsdk"
GSDK_OTBR_DIR="${GSDK_DIR}/util/third_party/ot-br-posix"
GSDK_OT_DIR="${GSDK_DIR}/util/third_party/openthread"

# Openthread repo path inside the OTBR repo
OTBR_DIR="${WORKDIR}/git/otbr"
OTBR_OT_DIR="${OTBR_DIR}/third_party/openthread/repo"

SRC_URI = "git://github.com/SiliconLabs/gecko_sdk.git;protocol=https;branch=gsdk_4.4;destsuffix=git/gsdk;name=gsdk"
SRCREV_gsdk= "9ad9e19638a2d0ce01ce21d32f5049c5f1b21d70"

SRC_URI += "gitsm://github.com/openthread/ot-br-posix.git;protocol=https;branch=main;destsuffix=git/otbr;name=otbr"
SRCREV_otbr = "dc6b912aa94320f2b2839260b2f18ee98379c5be"

SRCREV_FORMAT = "gsdk_otbr"

SRC_URI += "file://openthread-fix-build-errors.patch;patchdir=${GSDK_DIR} \
            file://adjust-otbr-configuration.patch;patchdir=${GSDK_DIR} \
            file://otbr-agent.service \
            file://otbr-agent.path \
"

S = "${GSDK_OTBR_DIR}"

DEPENDS += "mdns boost iproute2 jsoncpp ncurses readline cpcd pkgconfig protobuf protobuf-c-native dbus libnetfilter-queue libnetfilter-conntrack"
RDEPENDS_${PN} = "cpcd (= 4.4.1.0-r0)"

inherit cmake systemd pkgconfig

# Adding otbr version on to version.txt file
inherit add-version

# Manadatory thread certification flags
THREAD_CERT_FLAGS = " -DOTBR_DUA_ROUTING=ON \
                      -DOTBR_DNSSD_DISCOVERY_PROXY=ON \
                      -DOTBR_SRP_ADVERTISING_PROXY=ON \
                      -DOTBR_BORDER_ROUTING=ON \
                      -DOTBR_TREL=ON \
                      -DOTBR_NAT64=ON \
                      -DOT_TREL=ON \
                      -DOT_DNS_CLIENT=ON \
                      -DOT_DNSSD_SERVER=ON \
                      -DOT_SRP_CLIENT=ON \
                      -DOT_SRP_SERVER=ON \
                    "

# some of the options come from protocol/openthread/platform-abstraction/posix/openthread-core-silabs-posix-config.h
EXTRA_OECMAKE += " \
    -GNinja \
    -DOT_THREAD_VERSION=1.4 \
    -DCMAKE_BUILD_TYPE=Release  \
    ${THREAD_CERT_FLAGS} \
    -DOT_DHCP6_CLIENT=ON \
    -DOT_DHCP6_SERVER=ON \
    -DOTBR_DHCP6_PD=OFF \
    -DOTBR_DNS_UPSTREAM_QUERY=ON \
    -DBUILD_TESTING=OFF \
    -DOTBR_COVERAGE=OFF \
    -DOTBR_MDNS=mDNSResponder \
    -DOT_MLR=ON   \
    -DOTBR_DBUS=ON \
    -DOT_PLATFORM=posix \
    -DOT_ECDSA=ON   \
    -DOT_FIREWALL=OFF \
    -DOT_POSIX_CONFIG_RCP_VENDOR_DEPS_PACKAGE=${GSDK_DIR}/protocol/openthread/platform-abstraction/posix/posix_vendor_rcp.cmake \
    -DOT_POSIX_CONFIG_RCP_VENDOR_INTERFACE=${GSDK_DIR}/protocol/openthread/platform-abstraction/posix/cpc_interface.cpp \
    -DOT_CLI_VENDOR_EXTENSION=${GSDK_DIR}/protocol/openthread/platform-abstraction/posix/posix_vendor_cli.cmake \
    -DOT_MULTIPAN_RCP=ON \
    -DOT_POSIX_RCP_VENDOR_BUS=ON \
    -DOT_PLATFORM_CONFIG=${GSDK_DIR}/protocol/openthread/platform-abstraction/posix/openthread-core-silabs-posix-config.h \
    -DOT_POSIX_SETTINGS_PATH=\"/etc/thread\" \
    -DOT_CHANNEL_MANAGER=OFF \
    -DOT_CHANNEL_MONITOR=OFF \
    -DOTBR_BACKBONE_ROUTER=ON \
    -DOT_BACKBONE_ROUTER_DUA_NDPROXYING=ON \
    -DOT_BACKBONE_ROUTER_MULTICAST_ROUTING=ON \
"

CXXFLAGS += "-Wno-error=unused-but-set-variable"

# Update the source code of openthread and otbr within GSDK before executing do_populate_lic
# to verify the correct licenses
do_unpack[postfuncs] += "update_otbr"

update_otbr() {
    rm -rf ${GSDK_OTBR_DIR}
    rm -rf ${GSDK_OT_DIR}

    ln -sf ${OTBR_DIR} ${GSDK_OTBR_DIR}
    ln -sf ${OTBR_OT_DIR} ${GSDK_OT_DIR}
}

do_install_append() {
    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/otbr-agent.service ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/otbr-agent.path ${D}${systemd_system_unitdir}

    install -d ${D}${libdir}
    install -m 0644 ${WORKDIR}/build/src/dbus/common/*.a ${D}${libdir}
    install -m 0644 ${WORKDIR}/build/src/dbus/client/*.a ${D}${libdir}

    install -d ${D}${includedir}
    install -d ${D}${includedir}/otbr/common
    install -d ${D}${includedir}/otbr/openthread-br
    install -d ${D}${includedir}/otbr/dbus/common
    install -d ${D}${includedir}/otbr/dbus/client
    install -m 0644 ${S}/src/common/*.hpp ${D}${includedir}/otbr/common
    install -m 0644 ${S}/include/openthread-br/*.h ${D}${includedir}/otbr/openthread-br
    install -m 0644 ${S}/src/dbus/common/*.hpp ${D}${includedir}/otbr/dbus/common
    install -m 0644 ${S}/src/dbus/client/*.hpp ${D}${includedir}/otbr/dbus/client
    cp -R --no-dereference --preserve=mode,links ${OTBR_OT_DIR}/include/openthread ${D}${includedir}/otbr/
}

FILES_${PN} += "${systemd_system_unitdir}/"

# IMPORTANT! Do not add otbr-agent.service to the SYSTEMD_SERVICE define below. We don't want it automatically
# started. It will be started by otbr-agent.path
SYSTEMD_SERVICE_${PN} = "otbr-agent.path"
