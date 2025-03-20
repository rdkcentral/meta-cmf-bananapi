SUMMARY = "RDK WPS Monitor"
DESCRIPTION = "RDK WPS Button Monitor Service for detecting WPS button events"
SECTION = "base"
LICENSE = "Apache-2.0"

PV = "1.0+git${SRCPV}"
PR = "r4"

# Fetch the source code
SRC_URI = "git://github.com/rdkcentral/broadband-utils.git;protocol=https;branch=wpsmonitordev \
           file://rdk-wps-pbc.patch \
           file://netlink-button-monitor.service \
          "
           
# Use AUTOREV to get the latest commit
SRCREV = "${AUTOREV}"
#SRCREV += "886dc3870be13163ec42ace10fdb72ff1a10c55b"

S = "${WORKDIR}/git"

DEPENDS = "rbus"

CFLAGS_append += " -DRBUS_BUILD_INTEGRATED"
CFLAGS_append += " -DRBUS_BUILD_FLAG_ENABLE"

LDFLAGS_append += " -lrbus -lrtMessage -lrbuscore"
CFLAGS_append += " \
    -I${RECIPE_SYSROOT}/usr/include \
    -I${RECIPE_SYSROOT}/usr/include/rtmessage \
    -I${RECIPE_SYSROOT}/usr/include/rbus \
    "

# Override the license check
do_populate_lic[noexec] = "1"

inherit autotools pkgconfig systemd

# Add debug flags and verbose output
EXTRA_OEMAKE = "'CC=${CC}' 'CFLAGS=${CFLAGS} -g -Wall' 'LDFLAGS=${LDFLAGS}'"

do_configure[depends] += "rbus:do_populate_sysroot"
PARALLEL_MAKE = ""

do_compile() {
    cd ${S}/rdk-wps-monitor

    # Print directory contents for debugging
    echo "Contents of ${S}/rdk-wps-monitor:"
    ls -la
    
    # Check if Makefile exists
    if [ ! -f "Makefile" ]; then
        echo "ERROR: Makefile not found in ${S}/rdk-wps-monitor"
        exit 1
    fi

    # Verbose build
    oe_runmake V=1
    
    # Verify binary was created
    if [ ! -f "bin/netlink-button-monitor" ]; then
        echo "ERROR: Binary not created after compilation"
        exit 1
    fi
    
    # Check binary format
    file bin/netlink-button-monitor || echo "file command not available"
}

do_install() {
    # Create all directories first
    install -d ${D}${bindir}
    install -d ${D}${includedir}/netlink-wps
    install -d ${D}${systemd_unitdir}/system
    install -d ${D}${docdir}/netlink-wps
    
    # Check if binary exists before installing
    if [ -f "${S}/rdk-wps-monitor/bin/netlink-button-monitor" ]; then
        # Install binary with verbose output
        echo "Installing binary from ${S}/rdk-wps-monitor/bin/netlink-button-monitor to ${D}${bindir}"
        install -v -m 0755 ${S}/rdk-wps-monitor/bin/netlink-button-monitor ${D}${bindir}
        
        # Verify installation
        ls -la ${D}${bindir}
    else
        echo "ERROR: Binary not found at ${S}/rdk-wps-monitor/bin/netlink-button-monitor"
        exit 1
    fi
    
    # Install header files if they exist
    if [ -d "${S}/rdk-wps-monitor/include" ] && ls ${S}/rdk-wps-monitor/include/*.h >/dev/null 2>&1; then
        install -m 0644 ${S}/rdk-wps-monitor/include/*.h ${D}${includedir}/netlink-wps/
    else
        echo "WARNING: No header files found in ${S}/rdk-wps-monitor/include"
    fi
    
    # Install systemd service
    install -m 0644 ${WORKDIR}/netlink-button-monitor.service ${D}${systemd_unitdir}/system/
    
    # Install any scripts if they exist
    if [ -d "${S}/rdk-wps-monitor/scripts" ]; then
        install -d ${D}${datadir}/netlink-wps/scripts
        cp -R ${S}/rdk-wps-monitor/scripts/* ${D}${datadir}/netlink-wps/scripts/
        chmod 0755 ${D}${datadir}/netlink-wps/scripts/*
    fi
    
    # Install documentation
    if [ -f "${S}/rdk-wps-monitor/README.md" ]; then
        install -m 0644 ${S}/rdk-wps-monitor/README.md ${D}${docdir}/netlink-wps/
    fi
    if [ -f "${S}/rdk-wps-monitor/Readme" ]; then
        install -m 0644 ${S}/rdk-wps-monitor/Readme ${D}${docdir}/netlink-wps/
    fi
    
    # Create a placeholder license file
    echo "This software is licensed under the Apache License, Version 2.0." > ${D}${docdir}/netlink-wps/LICENSE
    echo "See http://www.apache.org/licenses/LICENSE-2.0 for the full license text." >> ${D}${docdir}/netlink-wps/LICENSE
}

# Skip debug tasks that would run objcopy
INHIBIT_PACKAGE_DEBUG_SPLIT = "1"
INHIBIT_PACKAGE_STRIP = "1"

FILES:${PN} += "${bindir}/netlink-button-monitor"
FILES:${PN} += "${systemd_unitdir}/system/netlink-button-monitor.service"
FILES:${PN} += "${datadir}/netlink-wps/scripts/*"
FILES:${PN}-doc += "${docdir}/netlink-wps/*"
FILES:${PN}-dev += "${includedir}/netlink-wps/*.h"

PACKAGES = "${PN} ${PN}-dev ${PN}-doc"

SYSTEMD_SERVICE:${PN} = "netlink-button-monitor.service"
SYSTEMD_AUTO_ENABLE = "enable"

