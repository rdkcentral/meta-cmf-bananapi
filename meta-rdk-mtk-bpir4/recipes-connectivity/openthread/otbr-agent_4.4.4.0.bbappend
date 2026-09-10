FILESEXTRAPATHS:prepend := "${THISDIR}/files:"


CXXFLAGS += "-fPIC"
CFLAGS += "-fPIC"
# Add BartonCore's patch to extend the OTBR D-Bus API
SRC_URI += "file://0003-Extend-d-bus-properties-and-signals.patch;patchdir=${GSDK_OTBR_DIR}"

do_unpack[network] = "1"

# Make sure the patched files are installed too
do_install:append() {
    # Make sure the D-Bus API files are properly installed
    install -d ${D}${includedir}/otbr/dbus/client
    install -d ${D}${includedir}/otbr/dbus/common
    install -d ${D}${includedir}/otbr/dbus/server
    
    # Install the extended client API headers
    install -m 0644 ${S}/src/dbus/client/thread_api_dbus.hpp ${D}${includedir}/otbr/dbus/client/
    install -m 0644 ${S}/src/dbus/client/thread_api_dbus.cpp ${D}${includedir}/otbr/dbus/client/
    
    # Install the constants header with the new constants
    install -m 0644 ${S}/src/dbus/common/constants.hpp ${D}${includedir}/otbr/dbus/common/
    
    # Install the server headers
    install -m 0644 ${S}/src/dbus/server/dbus_thread_object_rcp.hpp ${D}${includedir}/otbr/dbus/server/
}
