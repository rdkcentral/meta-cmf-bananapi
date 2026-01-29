do_install:append() {
        #Set the RFC_CONFIG_SERVER_URL by sed
        sed -i -e 's/RFC_CONFIG_SERVER_URL=.*$/RFC_CONFIG_SERVER_URL=https:\/\/xconf.rdkcentral.com\/featureControl\/getSettings/' ${D}${sysconfdir}/rfc.properties
}
CPPFLAGS:append:scarthgap = "-Wno-error=deprecated-declarations "

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI:append:scarthgap = " file://incomplete_type_Rfc.patch"
